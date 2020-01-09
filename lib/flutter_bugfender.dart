import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBugfender {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bugfender');

  /// Initialize the Bugfender SDK with a specific application token.
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

  /// Default Bugfender log method.
  /// 
  /// If [tag] is provided it'll be used as Tag for the log. 
  /// Otherwise "Info" tag will be applied.
  static Future<dynamic> log(String value, {String tag}) {
    Map<String, String> map = <String, String>{
      'log': value,
      'tag': tag ?? "Info",
    };

    return _channel.invokeMethod("log", map);
  }

  /// Extended Bugfender log method.
  /// 
  /// On Android will use `Info` log level and on iOS will use `BFLogLevelDefault`
  /// 
  /// If [tag] is provided it'll be used as Tag for the log. 
  /// Otherwise "Info" tag will be applied.
  /// 
  /// If [methodName] is provided it'll be used as method name in the log.
  /// Otherwise empty string will be applied.
  /// 
  /// If [className] is provided it'll be used as file name in the log.
  /// Otherwise empty string will be applied. 
  /// Using class name as file name is done on purpose.
  static Future<dynamic> l(String value, {String tag, String methodName, String className}) {
    Map<String, String> map = <String, String>{
      'log': value,
      'tag': tag ?? "Info",
      'methodName': methodName ?? "",
      'className': className ?? "",
    };

    return _channel.invokeMethod("logExtended", map);
  }

  /// Warning Bugfender log method.
  static Future<dynamic> warn(String value) {
    return _channel.invokeMethod("warn", value);
  }

  /// Error Bugfender log method.
  static Future<dynamic> error(String value) {
    return _channel.invokeMethod("error", value);
  }

  /// Synchronizes all logs and issues with the server once, regardless if this device is enabled or not. 
  /// 
  /// Logs and issues are synchronized only once. 
  /// After that, the logs are again sent according to the enabled flag in the Bugfender Console.
  static Future<dynamic> forceSendOnce() {
    return _channel.invokeMethod("forceSendOnce");
  }
}
