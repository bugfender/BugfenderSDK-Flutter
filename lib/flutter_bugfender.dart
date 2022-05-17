import 'dart:async';

import 'package:flutter_bugfender/flutter_bugfender_interface.dart';

final _flutterBugfenderInterface = FlutterBugfenderInterface.instance;

enum LogLevel { trace, debug, info, warning, error, fatal }

class FlutterBugfender {
  /// Init Bugfender
  static Future<void> init(
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
  }) =>
      _flutterBugfenderInterface.init(
        appKey,
        apiUri: apiUri,
        baseUri: baseUri,
        maximumLocalStorageSize: maximumLocalStorageSize,
        enableAndroidLogcatLogging: enableAndroidLogcatLogging,
        enableCrashReporting: enableCrashReporting,
        enableUIEventLogging: enableUIEventLogging,
        overrideDeviceName: overrideDeviceName,
        printToConsole: printToConsole,
        version: version,
        build: build,
      );

  /// Set a custom device key-value
  static Future<void> setDeviceString(String key, String value) =>
      _flutterBugfenderInterface.setDeviceString(key, value);

  /// Set a custom device key-value
  static Future<void> setDeviceInt(String key, int value) =>
      _flutterBugfenderInterface.setDeviceInt(key, value);

  /// Set a custom device key-value
  static Future<void> setDeviceFloat(String key, double value) =>
      _flutterBugfenderInterface.setDeviceFloat(key, value);

  /// Set a custom device key-value
  static Future<void> setDeviceBool(String key, bool value) =>
      _flutterBugfenderInterface.setDeviceBool(key, value);

  /// Remove a device key
  @Deprecated('use removeDeviceKey')
  static Future<void> removeDeviceString(String key) =>
      _flutterBugfenderInterface.removeDeviceKey(key);

  /// Remove a device key
  static Future<void> removeDeviceKey(String key) =>
      _flutterBugfenderInterface.removeDeviceKey(key);

  /// Send a crash to Bugfender
  static Future<Uri> sendCrash(String title, String stacktrace) =>
      _flutterBugfenderInterface.sendCrash(title, stacktrace);

  /// Send an issue to Bugfender
  static Future<Uri> sendIssue(String title, String text) =>
      _flutterBugfenderInterface.sendIssue(title, text);

  /// Send an issue to Bugfender
  @Deprecated("Use sendIssue instead")
  static Future<Uri> sendIssueMarkdown(String title, String markdown) =>
      _flutterBugfenderInterface.sendIssueMarkdown(title, markdown);

  /// Send an issue to Bugfender
  static Future<Uri> sendUserFeedback(String title, String text) =>
      _flutterBugfenderInterface.sendUserFeedback(title, text);

  /// Force enable sending logs and crashes to Bugfender and remember until reverted
  static Future<void> setForceEnabled(bool enabled) =>
      _flutterBugfenderInterface.setForceEnabled(enabled);

  /// Force enable sending logs and crashes to Bugfender, only for this session
  static Future<void> forceSendOnce() => _flutterBugfenderInterface.forceSendOnce();

  /// Gets the URL to see the logs of this device
  static Future<Uri> getDeviceUri() => _flutterBugfenderInterface.getDeviceUri();

  /// Gets the URL to see the logs of this session
  static Future<Uri> getSessionUri() => _flutterBugfenderInterface.getSessionUri();

  /// Send a log. Use this method if you need more control over the data sent
  /// while logging
  static Future<void> sendLog(
      {int line = 0,
        String method = "",
        String file: "",
        LogLevel level = LogLevel.debug,
        String tag = "",
        String text: ""}) =>
      _flutterBugfenderInterface.sendLog(
        line: line,
        method: method,
        file: file,
        level: level,
        tag: tag,
        text: text
      );

  /// Log something.
  static Future<void> log(String value) => _flutterBugfenderInterface.log(value);

  /// Send a log with fatal level.
  static Future<void> fatal(String value) => _flutterBugfenderInterface.fatal(value);

  /// Send a log with error level.
  static Future<void> error(String value) => _flutterBugfenderInterface.error(value);

  /// Send a log with warning level.
  static Future<void> warn(String value) => _flutterBugfenderInterface.warn(value);

  /// Send a log with info level.
  static Future<void> info(String value) => _flutterBugfenderInterface.info(value);

  /// Send a log with trace level.
  static Future<void> trace(String value) => _flutterBugfenderInterface.trace(value);

  /// Send a log with debug level.
  static Future<void> debug(String value) => _flutterBugfenderInterface.debug(value);

  /// Show a screen which asks for feedback.
  /// Once the user closes the modal or sends the feedback the Future promise resolves with the result.
  static Future<Uri?> getUserFeedback(
          {String title = "Feedback",
          String hint = "Please insert your feedback here and click send",
          String subjectHint = "Subject…",
          String messageHint = "Your feedback…",
          String sendButtonText = "Send",
          String cancelButtonText = "Close"}) =>
      _flutterBugfenderInterface.getUserFeedback(
          title: title,
          hint: hint,
          subjectHint: subjectHint,
          messageHint: messageHint,
          sendButtonText: sendButtonText,
          cancelButtonText: cancelButtonText);
}
