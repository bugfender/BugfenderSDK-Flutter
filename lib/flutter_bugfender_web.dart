import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';
import 'package:flutter_bugfender/flutter_bugfender_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_bugfender.dart';
import 'js_bugfender.dart' as bugfender_web;

// JS interop for global objects
@JS('Bugfender')
external JSObject? get bugfender;

@JS('Bugfender.init')
external JSPromise bugfenderInit(JSObject options);

@JS('document')
external JSObject get document;

@JS('document.querySelector')
external JSObject? querySelector(String selector);

@JS('document.createElement')
external JSObject createElement(String tagName);

class WebFlutterBugfender extends FlutterBugfenderInterface {
  static void registerWith(Registrar registrar) {
    FlutterBugfenderInterface.instance = WebFlutterBugfender();
  }

  @override
  Future<void> init(
    String appKey, {
    Uri? apiUri,
    Uri? baseUri,
    int? maximumLocalStorageSize, // note this is ignored in web
    bool printToConsole = true,
    bool enableUIEventLogging = true,
    bool enableCrashReporting = true,
    bool enableAndroidLogcatLogging = true,
    String? overrideDeviceName,
    String? version,
    String? build,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    // options keys are variable. For example, the "apiURL" key may or may not be present.
    // We can't use Dart classes with automatic conversion because Dart properties of a class are null when unset, but Bugfender.init() expects undefined.
    final options = <String, Object>{
      'appKey': appKey,
      'overrideConsoleMethods': false,
      'printToConsole': printToConsole,
      'registerErrorHandler': enableCrashReporting,
      'logBrowserEvents': enableUIEventLogging,
      'logUIEvents': enableUIEventLogging,
    };

    if (apiUri != null) {
      options['apiURL'] = apiUri.toString();
    }
    if (baseUri != null) {
      options['baseURL'] = baseUri.toString();
    }
    if (overrideDeviceName != null) {
      options['deviceName'] = overrideDeviceName;
    }
    if (version != null) {
      options['version'] = version;
    }
    if (build != null) {
      options['build'] = build;
    }
    return _initWithMap(options);
  }

  Future<void> _loadJSLibrary() async {
    final bf = bugfender;
    if (bf != null) {
      // Bugfender is already loaded, nothing to do
      print(
          'Bugfender: <script src="https://js.bugfender.com/bugfender-v2.js"></script> is no longer necessary in index.html');
      return;
    }

    final head = querySelector('head');
    if (head == null) {
      throw Exception('could not load Bugfender JS SDK (missing <head>)');
    }

    final script = createElement('script');

    // Set script properties using js_interop_unsafe
    script.setProperty('type'.toJS, 'text/javascript'.toJS);
    script.setProperty('charset'.toJS, 'utf-8'.toJS);
    script.setProperty('defer'.toJS, true.toJS);
    script.setProperty('src'.toJS,
        './assets/packages/flutter_bugfender/assets/bugfender.js'.toJS);

    // Add script to head
    head.callMethod('appendChild'.toJS, script);

    // wait for the script to load
    final completer = Completer<void>();
    script.callMethod(
        'addEventListener'.toJS,
        'load'.toJS,
        ((JSObject event) {
          completer.complete();
        }).toJS);

    return completer.future;
  }

  Future<void> _initWithMap(Map<String, Object> options) async {
    // load the JS library
    await _loadJSLibrary();

    // Convert Dart Map to JSObject
    final jsOptions = options.jsify() as JSObject;

    // call Bugfender.init(options)
    final jsPromise = bugfenderInit(jsOptions);

    // convert the JS Promise to a Dart Future
    await jsPromise.toDart;
  }

  @override
  Future<void> setDeviceString(String key, String value) async {
    bugfender_web.setDeviceKey(key, value.toJS);
  }

  @override
  Future<void> setDeviceInt(String key, int value) async {
    bugfender_web.setDeviceKey(key, value.toJS);
  }

  @override
  Future<void> setDeviceFloat(String key, double value) async {
    bugfender_web.setDeviceKey(key, value.toJS);
  }

  @override
  Future<void> setDeviceBool(String key, bool value) async {
    bugfender_web.setDeviceKey(key, value.toJS);
  }

  @override
  Future<void> removeDeviceKey(String key) async {
    bugfender_web.removeDeviceKey(key);
  }

  @override
  Future<Uri> sendCrash(String title, String stacktrace) async {
    final result = bugfender_web.sendCrash(title, stacktrace);
    final promiseResult = await result.toDart;
    return Uri.parse(promiseResult.toDart);
  }

  @override
  Future<Uri> sendIssue(String title, String text) async {
    final result = bugfender_web.sendIssue(title, text);
    final promiseResult = await result.toDart;
    return Uri.parse(promiseResult.toDart);
  }

  @override
  Future<Uri> sendIssueMarkdown(String title, String markdown) async {
    final result = bugfender_web.sendIssue(title, markdown);
    final promiseResult = await result.toDart;
    return Uri.parse(promiseResult.toDart);
  }

  @override
  Future<Uri> sendUserFeedback(String title, String text) async {
    final result = bugfender_web.sendUserFeedback(title, text);
    final promiseResult = await result.toDart;
    return Uri.parse(promiseResult.toDart);
  }

  @override
  Future<void> setForceEnabled(bool enabled) async {
    return bugfender_web.setForceEnabled(enabled);
  }

  @override
  Future<void> setSDKType(String sdkName, int sdkVersion) async {
    // no-op on web
  }

  @override
  Future<void> forceSendOnce() async {
    bugfender_web.forceSendOnce();
  }

  @override
  Future<Uri> getDeviceUri() async {
    final result = bugfender_web.getDeviceURL();
    final promiseResult = await result.toDart;
    return Uri.parse(promiseResult.toDart);
  }

  @override
  Future<Uri> getSessionUri() async {
    final result = bugfender_web.getSessionURL();
    final promiseResult = await result.toDart;
    return Uri.parse(promiseResult.toDart);
  }

  @override
  Future<void> sendLog(
      {int line = 0,
      String method = "",
      String file = "",
      LogLevel level = LogLevel.debug,
      String tag = "",
      String text = ""}) async {
    return bugfender_web.sendLog(bugfender_web.LogEntry(
        line: line,
        level: logLevelToInt(level),
        tag: tag,
        method: method,
        file: file,
        text: text,
        url: ""));
  }

  logLevelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
        return 3;
      case LogLevel.debug:
        return 0;
      case LogLevel.info:
        return 4;
      case LogLevel.warning:
        return 1;
      case LogLevel.error:
        return 2;
      case LogLevel.fatal:
        return 5;
    }
  }

  @override
  Future<void> log(String value) async {
    bugfender_web.log(value);
  }

  @override
  Future<void> fatal(String value) async {
    bugfender_web.fatal(value);
  }

  @override
  Future<void> error(String value) async {
    bugfender_web.error(value);
  }

  @override
  Future<void> warn(String value) async {
    bugfender_web.warn(value);
  }

  @override
  Future<void> info(String value) async {
    bugfender_web.info(value);
  }

  @override
  Future<void> trace(String value) async {
    bugfender_web.trace(value);
  }

  @override
  Future<void> debug(String value) async {
    bugfender_web.log(value);
  }

  @override
  Future<Uri?> getUserFeedback(
      {String title = "Feedback",
      String hint = "Please insert your feedback here and click send",
      String subjectHint = "Subject…",
      String messageHint = "Your feedback…",
      String sendButtonText = "Send",
      String cancelButtonText = "Close"}) async {
    final result =
        bugfender_web.getUserFeedback(bugfender_web.UserFeedbackOptions(
      title: title,
      hint: hint,
      subjectPlaceholder: subjectHint,
      feedbackPlaceholder: messageHint,
      submitLabel: sendButtonText,
    ));

    late bugfender_web.UserFeedbackResult feedbackResult;

    final promiseResult = await result.toDart;
    feedbackResult = promiseResult;

    if (feedbackResult.isSent) {
      return Uri.parse(feedbackResult.feedbackURL!);
    } else {
      return null;
    }
  }
}
