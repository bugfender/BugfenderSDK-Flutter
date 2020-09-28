import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBugfender {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bugfender');

  /// Init Bugfender
  static Future<dynamic> init(String appKey) {
    return _channel.invokeMethod("init", appKey);
  }

  /// Set this to null to remove user.
  static Future<dynamic> setDeviceString(String key, String value) {
    Map<String, String> map = <String, String>{
      'key': key,
      'value': value,
    };
    return _channel.invokeMethod("setDeviceString", map);
  }

  /// Remove a device string
  static Future<dynamic> removeDeviceString(String key) {
    return _channel.invokeMethod("removeDeviceString", key);
  }

  /// Send an issue to BugFender
  static Future<dynamic> sendIssue(String title, String value) {
    Map<String, String> issue = <String, String>{
      'title': title,
      'value': value,
    };
    return _channel.invokeMethod("sendIssue", issue);
  }

  /// Send an issue to BugFender
  static Future<dynamic> setForceEnabled(bool enabled) {
    return _channel.invokeMethod("setForceEnabled", enabled);
  }


  /// Log something.
  static Future<dynamic> log(String value) {
    return _channel.invokeMethod("log", value);
  }

  /// Send a log with fatal level.
  static Future<dynamic> fatal(String value) {
    return _channel.invokeMethod("fatal", value);
  }

  /// Send a log with error level.
  static Future<dynamic> error(String value) {
    return _channel.invokeMethod("error", value);
  }

  /// Send a log with warning level.
  static Future<dynamic> warn(String value) {
    return _channel.invokeMethod("warn", value);
  }

  /// Send a log with info level.
  static Future<dynamic> info(String value) {
    return _channel.invokeMethod("info", value);
  }

  /// Send a log with trace level.
  static Future<dynamic> trace(String value) {
    return _channel.invokeMethod("trace", value);
  }

  /// Send a log with debug level.
  static Future<dynamic> debug(String value) {
    return _channel.invokeMethod("debug", value);
  }
}
