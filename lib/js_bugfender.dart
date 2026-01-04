import 'dart:js_interop';

// init: proxying and automatic conversion doesn't work because the options object can have a variable number of keys

@JS('Bugfender')
external JSObject get _bugfender;

extension BugfenderExtension on JSObject {
  void setDeviceKey(String key, JSAny value) {
    (this as JSObject).callMethod('setDeviceKey'.toJS, [key.toJS, value]);
  }

  void removeDeviceKey(String key) {
    (this as JSObject).callMethod('removeDeviceKey'.toJS, [key.toJS]);
  }

  JSAny sendCrash(String title, String stacktrace) {
    return (this as JSObject).callMethod('sendCrash'.toJS, [title.toJS, stacktrace.toJS]);
  }

  JSAny sendIssue(String title, String text) {
    return (this as JSObject).callMethod('sendIssue'.toJS, [title.toJS, text.toJS]);
  }

  JSAny sendUserFeedback(String title, String markdown) {
    return (this as JSObject).callMethod('sendUserFeedback'.toJS, [title.toJS, markdown.toJS]);
  }

  void setForceEnabled(bool enabled) {
    (this as JSObject).callMethod('setForceEnabled'.toJS, [enabled.toJS]);
  }

  void setSDKType(String sdkName, String sdkVersion) {
    (this as JSObject).callMethod('setSDKType'.toJS, [sdkName.toJS, sdkVersion.toJS]);
  }

  JSAny getDeviceURL() {
    return (this as JSObject).callMethod('getDeviceURL'.toJS, []);
  }

  JSAny getSessionURL() {
    return (this as JSObject).callMethod('getSessionURL'.toJS, []);
  }

  void sendLog(LogEntry logEntry) {
    (this as JSObject).callMethod('sendLog'.toJS, [logEntry]);
  }

  void trace(String log) {
    (this as JSObject).callMethod('trace'.toJS, [log.toJS]);
  }

  void info(String log) {
    (this as JSObject).callMethod('info'.toJS, [log.toJS]);
  }

  void log(String log) {
    (this as JSObject).callMethod('log'.toJS, [log.toJS]);
  }

  void warn(String log) {
    (this as JSObject).callMethod('warn'.toJS, [log.toJS]);
  }

  void error(String log) {
    (this as JSObject).callMethod('error'.toJS, [log.toJS]);
  }

  void fatal(String log) {
    (this as JSObject).callMethod('fatal'.toJS, [log.toJS]);
  }

  void forceSendOnce() {
    (this as JSObject).callMethod('forceSendOnce'.toJS, []);
  }

  UserFeedbackResult getUserFeedback(UserFeedbackOptions options) {
    return (this as JSObject).callMethod('getUserFeedback'.toJS, [options]) as UserFeedbackResult;
  }
}

void setDeviceKey(String key, dynamic value) {
  _bugfender.setDeviceKey(key, value.toJS);
}

void removeDeviceKey(String key) {
  _bugfender.removeDeviceKey(key);
}

JSAny sendCrash(String title, String stacktrace) {
  return _bugfender.sendCrash(title, stacktrace);
}

JSAny sendIssue(String title, String text) {
  return _bugfender.sendIssue(title, text);
}

JSAny sendUserFeedback(String title, String markdown) {
  return _bugfender.sendUserFeedback(title, markdown);
}

void setForceEnabled(bool enabled) {
  _bugfender.setForceEnabled(enabled);
}

void setSDKType(String sdkName, String sdkVersion) {
  _bugfender.setSDKType(sdkName, sdkVersion);
}

JSAny getDeviceURL() {
  return _bugfender.getDeviceURL();
}

JSAny getSessionURL() {
  return _bugfender.getSessionURL();
}

void sendLog(LogEntry logEntry) {
  _bugfender.sendLog(logEntry);
}

void trace(String log) {
  _bugfender.trace(log);
}

void info(String log) {
  _bugfender.info(log);
}

void log(String log) {
  _bugfender.log(log);
}

void warn(String log) {
  _bugfender.warn(log);
}

void error(String log) {
  _bugfender.error(log);
}

void fatal(String log) {
  _bugfender.fatal(log);
}

void forceSendOnce() {
  _bugfender.forceSendOnce();
}

UserFeedbackResult getUserFeedback(UserFeedbackOptions options) {
  return _bugfender.getUserFeedback(options);
}

@JS()
@staticInterop
class LogEntry implements JSObject {
  external factory LogEntry({
    int? line,
    int? level,
    String? tag,
    String? method,
    String? file,
    String? text,
    String? url,
  });
}

extension LogEntryExtension on LogEntry {
  int get line => (this as JSObject)['line'.toJS] as int;
  int get level => (this as JSObject)['level'.toJS] as int;
  String get tag => ((this as JSObject)['tag'.toJS] as JSString).toDart;
  String get method => ((this as JSObject)['method'.toJS] as JSString).toDart;
  String get file => ((this as JSObject)['file'.toJS] as JSString).toDart;
  String get text => ((this as JSObject)['text'.toJS] as JSString).toDart;
  String get url => ((this as JSObject)['url'.toJS] as JSString).toDart;
}

@JS()
@staticInterop
class UserFeedbackOptions implements JSObject {
  external factory UserFeedbackOptions({
    String? title,
    String? hint,
    String? subjectPlaceholder,
    String? feedbackPlaceholder,
    String? submitLabel,
  });
}

extension UserFeedbackOptionsExtension on UserFeedbackOptions {
  String? get title => ((this as JSObject)['title'.toJS] as JSString?)?.toDart;
  String? get hint => ((this as JSObject)['hint'.toJS] as JSString?)?.toDart;
  String? get subjectPlaceholder => ((this as JSObject)['subjectPlaceholder'.toJS] as JSString?)?.toDart;
  String? get feedbackPlaceholder => ((this as JSObject)['feedbackPlaceholder'.toJS] as JSString?)?.toDart;
  String? get submitLabel => ((this as JSObject)['submitLabel'.toJS] as JSString?)?.toDart;
}

@JS()
@staticInterop
class UserFeedbackResult implements JSObject {
  external factory UserFeedbackResult();
}

extension UserFeedbackResultExtension on UserFeedbackResult {
  bool get isSent => (this as JSObject)['isSent'.toJS] as bool;
  String? get feedbackURL => ((this as JSObject)['feedbackURL'.toJS] as JSString?)?.toDart;
}
