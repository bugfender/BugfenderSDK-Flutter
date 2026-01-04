import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// init: proxying and automatic conversion doesn't work because the options object can have a variable number of keys

@JS('Bugfender')
external JSObject get _bugfender;

extension BugfenderExtension on JSObject {
  void setDeviceKey(String key, JSAny value) {
    jsObjectCallMethod(this, 'setDeviceKey'.toJS, [key.toJS, value].toJS);
  }

  void removeDeviceKey(String key) {
    jsObjectCallMethod(this, 'removeDeviceKey'.toJS, key.toJS);
  }

  JSAny sendCrash(String title, String stacktrace) {
    return jsObjectCallMethod(this, 'sendCrash'.toJS, [title.toJS, stacktrace.toJS].toJS);
  }

  JSAny sendIssue(String title, String text) {
    return jsObjectCallMethod(this, 'sendIssue'.toJS, [title.toJS, text.toJS].toJS);
  }

  JSAny sendUserFeedback(String title, String markdown) {
    return jsObjectCallMethod(this, 'sendUserFeedback'.toJS, [title.toJS, markdown.toJS].toJS);
  }

  void setForceEnabled(bool enabled) {
    jsObjectCallMethod(this, 'setForceEnabled'.toJS, enabled.toJS);
  }

  void setSDKType(String sdkName, String sdkVersion) {
    jsObjectCallMethod(this, 'setSDKType'.toJS, [sdkName.toJS, sdkVersion.toJS].toJS);
  }

  JSAny getDeviceURL() {
    return jsObjectCallMethod(this, 'getDeviceURL'.toJS, null);
  }

  JSAny getSessionURL() {
    return jsObjectCallMethod(this, 'getSessionURL'.toJS, null);
  }

  void sendLog(LogEntry logEntry) {
    jsObjectCallMethod(this, 'sendLog'.toJS, logEntry);
  }

  void trace(String log) {
    jsObjectCallMethod(this, 'trace'.toJS, log.toJS);
  }

  void info(String log) {
    jsObjectCallMethod(this, 'info'.toJS, log.toJS);
  }

  void log(String log) {
    jsObjectCallMethod(this, 'log'.toJS, log.toJS);
  }

  void warn(String log) {
    jsObjectCallMethod(this, 'warn'.toJS, log.toJS);
  }

  void error(String log) {
    jsObjectCallMethod(this, 'error'.toJS, log.toJS);
  }

  void fatal(String log) {
    jsObjectCallMethod(this, 'fatal'.toJS, log.toJS);
  }

  void forceSendOnce() {
    jsObjectCallMethod(this, 'forceSendOnce'.toJS, null);
  }

  UserFeedbackResult getUserFeedback(UserFeedbackOptions options) {
    return jsObjectCallMethod(this, 'getUserFeedback'.toJS, options) as UserFeedbackResult;
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
  int get line => jsObjectGetProperty(this, 'line'.toJS) as int;
  int get level => jsObjectGetProperty(this, 'level'.toJS) as int;
  String get tag => (jsObjectGetProperty(this, 'tag'.toJS) as JSString).toDart;
  String get method => (jsObjectGetProperty(this, 'method'.toJS) as JSString).toDart;
  String get file => (jsObjectGetProperty(this, 'file'.toJS) as JSString).toDart;
  String get text => (jsObjectGetProperty(this, 'text'.toJS) as JSString).toDart;
  String get url => (jsObjectGetProperty(this, 'url'.toJS) as JSString).toDart;
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
  String? get title => (jsObjectGetProperty(this, 'title'.toJS) as JSString?)?.toDart;
  String? get hint => (jsObjectGetProperty(this, 'hint'.toJS) as JSString?)?.toDart;
  String? get subjectPlaceholder => (jsObjectGetProperty(this, 'subjectPlaceholder'.toJS) as JSString?)?.toDart;
  String? get feedbackPlaceholder => (jsObjectGetProperty(this, 'feedbackPlaceholder'.toJS) as JSString?)?.toDart;
  String? get submitLabel => (jsObjectGetProperty(this, 'submitLabel'.toJS) as JSString?)?.toDart;
}

@JS()
@staticInterop
class UserFeedbackResult implements JSObject {
  external factory UserFeedbackResult();
}

extension UserFeedbackResultExtension on UserFeedbackResult {
  bool get isSent => jsObjectGetProperty(this, 'isSent'.toJS) as bool;
  String? get feedbackURL => (jsObjectGetProperty(this, 'feedbackURL'.toJS) as JSString?)?.toDart;
}
