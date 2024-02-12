import 'dart:async';
import 'dart:html' as html;
import 'dart:js';
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
    var options = {
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
    JsObject? bf = context['Bugfender'];
    if (bf != null) {
      // Bugfender is already loaded, nothing to do
      print(
          'Bugfender: <script src="https://js.bugfender.com/bugfender-v2.js"></script> is no longer necessary in index.html');
      return Future.value();
    }

    final head = html.querySelector('head');
    if (head == null) {
      return Future.error('could not load Bugfender JS SDK (missing <head>)');
    }
    final html.ScriptElement script = html.ScriptElement()
      ..type = "text/javascript"
      ..charset = "utf-8"
      ..defer = true
      ..src = './assets/packages/flutter_bugfender/assets/bugfender.js';
    head.children.add(script);

    // wait for the script to load
    final completer = new Completer<void>();
    script.addEventListener('load', (event) => {completer.complete()});
    return completer.future;
  }

  Future<void> _initWithMap(Map<String, Object> options) async {
    // load the JS library
    await _loadJSLibrary();

    // call Bugfender.init(options)
    JsObject jsPromise =
        context['Bugfender'].callMethod('init', [JsObject.jsify(options)]);

    // convert the JS Promise to a Dart Future
    final completer = new Completer<void>();
    jsPromise.callMethod('then', [
      allowInterop(completer.complete),
      allowInterop(completer.completeError)
    ]);
    return completer.future;
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
