import 'dart:js_util';

import 'package:flutter/widgets.dart';
import 'package:flutter_bugfender/flutter_bugfender_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_bugfender.dart';
import 'js_bugfender.dart' as bugfender_web;

class WebFlutterBugfender extends FlutterBugfenderInterface {
  static void registerWith(Registrar registrar) {
    FlutterBugfenderInterface.instance = WebFlutterBugfender();
  }

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
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    return promiseToFuture(bugfender_web.init(bugfender_web.Options(
      appKey: appKey,
      apiURL: apiUri?.toString() ?? 'https://api.bugfender.com',
      baseURL: baseUri?.toString() ?? 'https://dashboard.bugfender.com',
      overrideConsoleMethods: false,
      printToConsole: printToConsole,
      registerErrorHandler: enableCrashReporting,
      logBrowserEvents: enableUIEventLogging,
      logUIEvents: enableUIEventLogging,
      deviceName: overrideDeviceName,
      version: version ?? '',
      build: build ?? '',
    )));
  }

  @override
  Future<void> setDeviceString(String key, String value) async {
    bugfender_web.setDeviceKey(key, value);
  }

  @override
  Future<void> setDeviceInt(String key, int value) async {
    bugfender_web.setDeviceKey(key, value);
  }

  @override
  Future<void> setDeviceFloat(String key, double value) async {
    bugfender_web.setDeviceKey(key, value);
  }

  @override
  Future<void> setDeviceBool(String key, bool value) async {
    bugfender_web.setDeviceKey(key, value);
  }

  @override
  Future<void> removeDeviceKey(String key) async {
    bugfender_web.removeDeviceKey(key);
  }

  @override
  Future<Uri> sendCrash(String title, String stacktrace) async {
    return promiseToFuture(bugfender_web.sendCrash(title, stacktrace))
        .then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> sendIssue(String title, String text) async {
    return promiseToFuture(bugfender_web.sendIssue(title, text))
        .then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> sendIssueMarkdown(String title, String markdown) async {
    return promiseToFuture(bugfender_web.sendIssue(title, markdown))
        .then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> sendUserFeedback(String title, String text) async {
    return promiseToFuture(bugfender_web.sendUserFeedback(title, text))
        .then((value) => Uri.parse(value));
  }

  @override
  Future<void> setForceEnabled(bool enabled) async {
    return bugfender_web.setForceEnabled(enabled);
  }

  @override
  Future<void> forceSendOnce() async {
    bugfender_web.forceSendOnce();
  }

  @override
  Future<Uri> getDeviceUri() async {
    return promiseToFuture(bugfender_web.getDeviceURL())
        .then((value) => Uri.parse(value));
  }

  @override
  Future<Uri> getSessionUri() async {
    return promiseToFuture(bugfender_web.getSessionURL())
        .then((value) => Uri.parse(value));
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
        method: method,
        file: file,
        level: logLevelToInt(level),
        tag: tag,
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

  Future<Uri?> getUserFeedback(
      {String title = "Feedback",
      String hint = "Please insert your feedback here and click send",
      String subjectHint = "Subject…",
      String messageHint = "Your feedback…",
      String sendButtonText = "Send",
      String cancelButtonText = "Close"}) {
    return promiseToFuture(
        bugfender_web.getUserFeedback(bugfender_web.UserFeedbackOptions(
      title: title,
      hint: hint,
      subjectPlaceholder: subjectHint,
      feedbackPlaceholder: messageHint,
      submitLabel: sendButtonText,
    ))).then((value) {
      var result = (value as bugfender_web.UserFeedbackResult);
      if (result.isSent) {
        return Uri.parse(result.feedbackURL!);
      } else {
        return null;
      }
    });
  }
}
