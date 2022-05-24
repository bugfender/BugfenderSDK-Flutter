@JS()
library bugfender;

import 'package:js/js.dart';

@JS('Bugfender.init')
external Object init(Options options);
// Returning Object instead of void to be able to make use of promiseToFuture
// on flutter_bugfender_web.dart

@JS('Bugfender.setDeviceKey')
external void setDeviceKey(String key, dynamic value);

@JS('Bugfender.removeDeviceKey')
external void removeDeviceKey(String key);

@JS('Bugfender.sendCrash')
external String sendCrash(String title, String stacktrace);

@JS('Bugfender.sendIssue')
external String sendIssue(String title, String text);

@JS('Bugfender.sendUserFeedback')
external String sendUserFeedback(String title, String markdown);

@JS('Bugfender.getDeviceURL')
external String getDeviceURL();

@JS('Bugfender.getSessionURL')
external String getSessionURL();

@JS('Bugfender.sendLog')
external sendLog(LogEntry logEntry);

@JS('Bugfender.trace')
external void trace(String log);

@JS('Bugfender.info')
external void info(String log);

@JS('Bugfender.log')
external void log(String log);

@JS('Bugfender.warn')
external void warn(String log);

@JS('Bugfender.error')
external void error(String log);

@JS('Bugfender.fatal')
external void fatal(String log);

@JS('Bugfender.forceSendOnce')
external void forceSendOnce();

@JS('Bugfender.getUserFeedback')
external UserFeedbackResult getUserFeedback(UserFeedbackOptions userFeedbackOptions);

@JS()
@anonymous
class LogEntry {
  external int get line;

  external int get level;

  external String get tag;

  external String get method;

  external String get file;

  external String get text;

  external String get url;

  external factory LogEntry({
    int line,
    int level,
    String tag,
    String method,
    String file,
    String text,
    String url,
  });
}

@JS()
@anonymous
class UserFeedbackOptions {
  external String? get  title;
  external String? get hint;
  external String? get subjectPlaceholder;
  external String? get feedbackPlaceholder;
  external String? get submitLabel;

  external factory UserFeedbackOptions({
    String? title,
    String? hint,
    String? subjectPlaceholder,
    String? feedbackPlaceholder,
    String? submitLabel,
  });
}

@JS()
class UserFeedbackResult {
  external bool get isSent;
  external String? get feedbackURL;
}

@JS()
@anonymous
class Options {
  external String get appKey;

  external String? get apiURL;

  external String? get baseURL;

  external String? get deviceName;

  external bool get overrideConsoleMethods;

  external bool get printToConsole;

  external bool get registerErrorHandler;

  external bool get logBrowserEvents;

  external bool get logUIEvents;

  external String? get version;

  external String? get build;

  external factory Options({
    String appKey,
    String? apiURL,
    String? baseURL,
    bool overrideConsoleMethods,
    bool printToConsole,
    bool registerErrorHandler,
    bool logBrowserEvents,
    bool logUIEvents,
    String? deviceName,
    String? version,
    String? build,
  });
}
