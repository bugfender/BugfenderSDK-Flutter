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

  /// Log something.
  static Future<dynamic> log(String value) {
    return _channel.invokeMethod("log", value);
  }

  /// Warn about something.
  static Future<dynamic> warn(String value) {
    return _channel.invokeMethod("warn", value);
  }

  /// Send an error.
  static Future<dynamic> error(String value) {
    return _channel.invokeMethod("error", value);
  }
}
