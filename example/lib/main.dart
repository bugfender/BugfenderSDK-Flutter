import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';

const _channel = MethodChannel('flutter_bugfender');

/// Set to `false` for production so [apiUri]/[baseUri] are omitted and the SDK
/// uses its default (production) hosts.
const _useLocalBugfender = true;

/// Replace with your Bugfender app key (from the Bugfender dashboard).
const _bugfenderAppKey = 'iCxlNvC8sWYH1gm0QR1bW0EIHDUylKPg';

/// Local/dev only: host for a Bugfender stack running on your machine.
/// - Android emulator: use `10.0.2.2` (loopback to the host).
/// - Physical device / iOS simulator: replace with your machine's LAN IP
///   (e.g. `192.168.70.107`).
/// Unused when [_useLocalBugfender] is `false`.
String get _bugfenderHost =>
    Platform.isAndroid ? '10.0.2.2' : '192.168.70.107';

Future<Map<Object?, Object?>> _sendInstrumentedRequest({
  required String url,
  String method = 'GET',
  String? body,
  Map<String, String>? headers,
}) async {
  final result = await _channel.invokeMethod<dynamic>(
    'sendInstrumentedNetworkRequest',
    <String, dynamic>{
      'url': url,
      'method': method,
      if (body != null) 'body': body,
      if (headers != null) 'headers': headers,
    },
  );
  if (result is Map) {
    return Map<Object?, Object?>.from(result);
  }
  return <Object?, Object?>{'status': result};
}

void main() {
  FlutterBugfender.handleUncaughtErrors(() async {
    // Local: pass apiUri/baseUri pointing at your machine.
    // Production: set [_useLocalBugfender] to false (omit overrides → SDK defaults).
    await FlutterBugfender.init(
      _bugfenderAppKey,
      apiUri: _useLocalBugfender
          ? Uri.parse('http://$_bugfenderHost:3100/')
          : null,
      baseUri: _useLocalBugfender
          ? Uri.parse('https://$_bugfenderHost:3000/')
          : null,
      printToConsole: true,
      enableCrashReporting: true,
      enableAndroidLogcatLogging: false,
      version: "1.0",
      build: "555",
    );

    FlutterBugfender.log("hello world!");
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = 'Bugfender not started';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPlatformState();
    });
  }

  Future<void> initPlatformState() async {
    try {
      FlutterBugfender.log("Working fine!");
      await _runNetworkLoggingSuite();
      FlutterBugfender.forceSendOnce();
      print(await FlutterBugfender.getDeviceUri());
      print(await FlutterBugfender.getSessionUri());
    } catch (e) {
      print("Error found!!!! $e");
      setState(() {
        _message = 'Suite failed: $e';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _message = "Network suite finished — check bf_network / Network tab";
    });
  }

  Future<void> _runNetworkLoggingSuite() async {
    final buffer = StringBuffer();

    // 1) Enable + body capture + obfuscation handlers
    await FlutterBugfender.setNetworkLoggingEnabled(true);
    await FlutterBugfender.setNetworkLoggingCaptureBodies(true);
    await FlutterBugfender.setNetworkLoggingCaptureErrorResponseBodies(false);
    await FlutterBugfender.setNetworkLoggingURLFilter(
      allowlist: null,
      denylist: null,
    );
    await FlutterBugfender.setNetworkLoggingMaxRequestsPerMinute(null);

    await FlutterBugfender.setNetworkLoggingRequestObfuscationHandler(
      (url, headers, body) {
        final safeHeaders = Map<String, String>.from(headers);
        safeHeaders['Authorization'] = '***REDACTED***';
        safeHeaders.remove('authorization');
        final safeBody = body?.replaceAll(
          RegExp(r'"password"\s*:\s*"[^"]*"'),
          '"password":"***REDACTED***"',
        );
        FlutterBugfender.log(
          'obfuscate-request called url=$url auth=${safeHeaders['Authorization']}',
        );
        return NetworkRequestData(
          url: url,
          headers: safeHeaders,
          body: safeBody,
        );
      },
    );
    await FlutterBugfender.setNetworkLoggingResponseObfuscationHandler(
      (headers, body) {
        final safeHeaders = Map<String, String>.from(headers);
        safeHeaders['Set-Cookie'] = '***REDACTED***';
        FlutterBugfender.log('obfuscate-response called');
        return NetworkResponseData(headers: safeHeaders, body: body);
      },
    );

    // 2) Captured + obfuscated POST
    final obfuscated = await _sendInstrumentedRequest(
      url: 'https://example.com/login',
      method: 'POST',
      body: '{"user":"sirAlif","password":"super-secret"}',
      headers: const {'Authorization': 'Bearer secret-token'},
    );
    buffer.writeln(
      'obfuscated POST status=${obfuscated['status']} capture=${obfuscated['shouldCapture']}',
    );

    // 3) Denylist should skip capture
    await FlutterBugfender.setNetworkLoggingURLFilter(
      denylist: const ['*/denied/*'],
    );
    final denied = await _sendInstrumentedRequest(
      url: 'https://example.com/denied/secret',
    );
    buffer.writeln(
      'denylist status=${denied['status']} capture=${denied['shouldCapture']}',
    );

    // 4) Allowlist should only capture matching URLs
    await FlutterBugfender.setNetworkLoggingURLFilter(
      allowlist: const ['https://example.com/allowed/*'],
      denylist: null,
    );
    final allowedMiss = await _sendInstrumentedRequest(
      url: 'https://example.com/other',
    );
    final allowedHit = await _sendInstrumentedRequest(
      url: 'https://example.com/allowed/item',
    );
    buffer.writeln(
      'allow miss capture=${allowedMiss['shouldCapture']} hit capture=${allowedHit['shouldCapture']}',
    );

    // 5) Error-body-only mode
    await FlutterBugfender.setNetworkLoggingURLFilter(
      allowlist: null,
      denylist: null,
    );
    await FlutterBugfender.setNetworkLoggingCaptureBodies(false);
    await FlutterBugfender.setNetworkLoggingCaptureErrorResponseBodies(true);
    final errorBody = await _sendInstrumentedRequest(
      url: 'https://example.com/not-found-bf-test',
    );
    buffer.writeln(
      'error-body mode status=${errorBody['status']} capture=${errorBody['shouldCapture']}',
    );

    // 6) Rate limit: only first request in the minute should capture after limit=1
    await FlutterBugfender.setNetworkLoggingCaptureBodies(true);
    await FlutterBugfender.setNetworkLoggingMaxRequestsPerMinute(1);
    final rate1 = await _sendInstrumentedRequest(
      url: 'https://example.com/rate-1',
    );
    final rate2 = await _sendInstrumentedRequest(
      url: 'https://example.com/rate-2',
    );
    buffer.writeln(
      'rate1 capture=${rate1['shouldCapture']} rate2 capture=${rate2['shouldCapture']}',
    );

    // Reset for interactive button
    await FlutterBugfender.setNetworkLoggingMaxRequestsPerMinute(null);
    await FlutterBugfender.setNetworkLoggingURLFilter(
      allowlist: null,
      denylist: null,
    );
    await FlutterBugfender.setNetworkLoggingCaptureBodies(true);

    FlutterBugfender.log('network-suite: ${buffer.toString().trim()}');
    print(buffer.toString());
  }

  Future<void> getUserFeedback() async {
    print(await FlutterBugfender.getUserFeedback());
  }

  void generateException() {
    var _ = 100 ~/ 0;
  }

  void generateError() {
    throw Error();
  }

  Future<void> sendTestNetworkRequest() async {
    try {
      final result = await _sendInstrumentedRequest(
        url: 'https://example.com/',
        method: 'POST',
        body: '{"ping":true,"password":"button-secret"}',
        headers: const {'Authorization': 'Bearer button-token'},
      );
      FlutterBugfender.forceSendOnce();
      setState(() {
        _message =
            'Button request status=${result['status']} capture=${result['shouldCapture']}';
      });
    } catch (e) {
      FlutterBugfender.error('Test network request failed: $e');
      setState(() {
        _message = 'Network request failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bugfender Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$_message\n'),
              ElevatedButton(
                onPressed: getUserFeedback,
                child: const Text('Show Feedback Screen'),
              ),
              ElevatedButton(
                onPressed: sendTestNetworkRequest,
                child: const Text('Send test network request'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() => _message = 'Running network suite...');
                  await _runNetworkLoggingSuite();
                  await FlutterBugfender.forceSendOnce();
                  if (!mounted) return;
                  setState(() {
                    _message =
                        'Network suite finished — check bf_network / Network tab';
                  });
                },
                child: const Text('Re-run network suite'),
              ),
              ElevatedButton(
                onPressed: generateException,
                child: const Text('Generate exception'),
              ),
              ElevatedButton(
                onPressed: generateError,
                child: const Text('Generate error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
