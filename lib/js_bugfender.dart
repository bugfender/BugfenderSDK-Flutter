@JS()
library bugfender;

import 'package:js/js.dart';

@JS('Bugfender.init')
external void init(Options options);

@JS('Bugfender.setDeviceKey')
external void setDeviceKey(String key, dynamic value);

@JS('Bugfender.removeDeviceKey')
external void removeDeviceKey(String key);

@JS('Bugfender.sendCrash')
external String sendCrash(String title, String stacktrace);

@JS('Bugfender.sendIssue')
external String sendIssue(String title, String text);

@JS('Bugfender.sendIssueMarkdown')
external String sendIssueMarkdown(String title, String markdown);

@JS('Bugfender.sendUserFeedback')
external String sendUserFeedback(String title, String markdown);

@JS('Bugfender.getDeviceURL')
external String getDeviceURL();

@JS('Bugfender.getSessionURL')
external String getSessionURL();

@JS('Bugfender.trace')
external void trace(String tag, String log);

@JS('Bugfender.info')
external void info(String tag, String log);

@JS('Bugfender.log')
external void log(String tag, String log);

@JS('Bugfender.warn')
external void warn(String tag, String log);

@JS('Bugfender.error')
external void error(String tag, String log);

@JS('Bugfender.fatal')
external void fatal(String tag, String log);

@JS()
@anonymous
class Options {
  external String get appKey;

  external String? get apiURL;

  external String? get baseURL;

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
    String? version,
    String? build,
  });
}
