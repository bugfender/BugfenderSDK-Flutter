import 'package:flutter_bugfender/flutter_bugfender_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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
    bugfender_web.init(bugfender_web.Options(
      appKey: appKey,
      apiURL: apiUri?.toString() ?? 'https://api.bugfender.com',
      baseURL: baseUri?.toString() ?? 'https://dashboard.bugfender.com',
      overrideConsoleMethods: printToConsole,
      printToConsole: printToConsole,
      registerErrorHandler: true,
      logBrowserEvents: enableUIEventLogging,
      logUIEvents: enableUIEventLogging,
      version: version,
      build: build,
    ));
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
    return Uri.parse(bugfender_web.sendCrash(title, stacktrace));
  }

  @override
  Future<Uri> sendIssue(String title, String text) async {
    return Uri.parse(bugfender_web.sendIssue(title, text));
  }

  @override
  Future<Uri> sendIssueMarkdown(String title, String markdown) async {
    return Uri.parse(bugfender_web.sendIssueMarkdown(title, markdown));
  }

  @override
  Future<Uri> sendUserFeedback(String title, String markdown) async {
    return Uri.parse(bugfender_web.sendUserFeedback(title, markdown));
  }

  @override
  Future<void> setForceEnabled(bool enabled) async {
    //todo not supported on web sdk
  }

  @override
  Future<void> forceSendOnce() async {
    //todo not supported on web sdk
  }

  @override
  Future<Uri> getDeviceUri() async {
    return Uri.parse(bugfender_web.getDeviceURL());
  }

  @override
  Future<Uri> getSessionUri() async {
    return Uri.parse(bugfender_web.getSessionURL());
  }

  @override
  Future<void> log(String value) async {
    bugfender_web.log("", value);
  }

  @override
  Future<void> fatal(String value) async {
    bugfender_web.fatal("", value);
  }

  @override
  Future<void> error(String value) async {
    bugfender_web.error("", value);
  }

  @override
  Future<void> warn(String value) async {
    bugfender_web.warn("", value);
  }

  @override
  Future<void> info(String value) async {
    bugfender_web.info("", value);
  }

  @override
  Future<void> trace(String value) async {
    bugfender_web.trace("", value);
  }

  @override
  Future<void> debug(String value) async {
    //not found debug() on web sdk
    bugfender_web.log("", value);
  }
}
