import 'dart:js_interop';

// External function declarations
@JS('Bugfender.setDeviceKey')
external void setDeviceKey(String key, JSAny value);

@JS('Bugfender.removeDeviceKey')
external void removeDeviceKey(String key);

@JS('Bugfender.sendCrash')
external JSPromise<JSString> sendCrash(String title, String stacktrace);

@JS('Bugfender.sendIssue')
external JSPromise<JSString> sendIssue(String title, String text);

@JS('Bugfender.sendUserFeedback')
external JSPromise<JSString> sendUserFeedback(String title, String markdown);

@JS('Bugfender.setForceEnabled')
external void setForceEnabled(bool enabled);

@JS('Bugfender.setSDKType')
external void setSDKType(String sdkName, String sdkVersion);

@JS('Bugfender.getDeviceURL')
external JSPromise<JSString> getDeviceURL();

@JS('Bugfender.getSessionURL')
external JSPromise<JSString> getSessionURL();

@JS('Bugfender.sendLog')
external void sendLog(LogEntry logEntry);

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
external JSPromise<UserFeedbackResult> getUserFeedback(
    UserFeedbackOptions userFeedbackOptions);

// Extension types for interop objects
extension type LogEntry._(JSObject _) implements JSObject {
  external factory LogEntry({
    int line,
    int level,
    String tag,
    String method,
    String file,
    String text,
    String url,
  });
  
  external int get line;
  external int get level;
  external String get tag;
  external String get method;
  external String get file;
  external String get text;
  external String get url;
}

extension type UserFeedbackOptions._(JSObject _) implements JSObject {
  external factory UserFeedbackOptions({
    String? title,
    String? hint,
    String? subjectPlaceholder,
    String? feedbackPlaceholder,
    String? submitLabel,
  });
  
  external String? get title;
  external String? get hint;
  external String? get subjectPlaceholder;
  external String? get feedbackPlaceholder;
  external String? get submitLabel;
}

extension type UserFeedbackResult._(JSObject _) implements JSObject {
  external bool get isSent;
  external String? get feedbackURL;
}
