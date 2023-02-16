import 'package:flutter/services.dart';
import 'package:flutter_bugfender/flutter_bugfender_interface.dart';
import 'flutter_bugfender.dart';

class MethodChannelFlutterBugfender extends FlutterBugfenderInterface {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bugfender');

  @override
  Future<void> init(
    String appKey, {
    Uri? apiUri,
    Uri? baseUri,
    int? maximumLocalStorageSize,
    bool printToConsole = true,
    bool enableUIEventLogging = true,
    bool enableCrashReporting = true,
    bool enableAndroidLogcatLogging = true,
    String? overrideDeviceName,
    String? version,
    String? build,
  }) {
    Map<String, Object> map = <String, Object>{
      'appKey': appKey,
      'apiUri': apiUri != null ? apiUri.toString() : '',
      'baseUri': baseUri != null ? baseUri.toString() : '',
      'maximumLocalStorageSize': maximumLocalStorageSize ?? 0,
      'printToConsole': printToConsole,
      'enableUIEventLogging': enableUIEventLogging,
      'enableCrashReporting': enableCrashReporting,
      'enableAndroidLogcatLogging': enableAndroidLogcatLogging,
      'overrideDeviceName': overrideDeviceName ?? '',
    };
    return _channel.invokeMethod('init', map);
  }

  @override
  Future<void> setDeviceString(String key, String value) {
    return _channel.invokeMethod('setDeviceString', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<void> setDeviceInt(String key, int value) {
    return _channel.invokeMethod('setDeviceInt', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<void> setDeviceFloat(String key, double value) {
    return _channel.invokeMethod('setDeviceFloat', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<void> setDeviceBool(String key, bool value) {
    return _channel.invokeMethod('setDeviceBool', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<void> removeDeviceKey(String key) {
    return _channel.invokeMethod('removeDeviceKey', key);
  }

  @override
  Future<Uri> sendCrash(String title, String stacktrace) {
    return _channel.invokeMethod('sendCrash', {
      'title': title,
      'value': stacktrace,
    }).then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> sendIssue(String title, String text) {
    return _channel.invokeMethod('sendIssue', {
      'title': title,
      'value': '```\n' + text + '\n```',
    }).then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> sendIssueMarkdown(String title, String markdown) {
    return _channel.invokeMethod('sendIssue', {
      'title': title,
      'value': markdown,
    }).then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> sendUserFeedback(String title, String text) {
    return _channel.invokeMethod('sendUserFeedback', {
      'title': title,
      'value': text,
    }).then((value) => Uri.parse(value));
  }

  @override
  Future<void> setForceEnabled(bool enabled) {
    return _channel.invokeMethod('setForceEnabled', enabled);
  }

  @override
  Future<void> forceSendOnce() {
    return _channel.invokeMethod('forceSendOnce');
  }

  @override
  Future<Uri> getDeviceUri() {
    return _channel
        .invokeMethod('getDeviceUri')
        .then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> getSessionUri() {
    return _channel
        .invokeMethod('getSessionUri')
        .then((value) => Uri.parse(value));
  }

  @override
  Future<void> sendLog(
      {int line = 0,
        String method = "",
        String file = "",
        LogLevel level = LogLevel.debug,
        String tag = "",
        String text = ""}) {
    return _channel.invokeMethod('sendLog', {
      "line": line,
      "method": method,
      "file": file,
      "level": level.index,
      "tag": tag,
      "text": text
    });
  }

  @override
  Future<void> log(String value) {
    return _channel.invokeMethod('log', value);
  }

  @override
  Future<void> fatal(String value) {
    return _channel.invokeMethod('fatal', value);
  }

  @override
  Future<void> error(String value) {
    return _channel.invokeMethod('error', value);
  }

  @override
  Future<void> warn(String value) {
    return _channel.invokeMethod('warn', value);
  }

  @override
  Future<void> info(String value) {
    return _channel.invokeMethod('info', value);
  }

  @override
  Future<void> trace(String value) {
    return _channel.invokeMethod('trace', value);
  }

  @override
  Future<void> debug(String value) {
    return _channel.invokeMethod('debug', value);
  }

  @override
  Future<Uri?> getUserFeedback(
      {String title = "Feedback",
      String hint = "Please insert your feedback here and click send",
      String subjectHint = "Subject…",
      String messageHint = "Your feedback…",
      String sendButtonText = "Send",
      String cancelButtonText = "Close"}) {
    return _channel.invokeMethod('getUserFeedback', {
      "title": title,
      "hint": hint,
      "subjectHint": subjectHint,
      "messageHint": messageHint,
      "sendButtonText": sendButtonText,
      "cancelButtonText": cancelButtonText
    }).then((value) {
      if (value != null) {
        return Uri.parse(value);
      } else {
        return null;
      }
    });
  }
}
