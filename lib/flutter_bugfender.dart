import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBugfender {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bugfender');

  /// Init Bugfender
  static Future<void> init(String appKey) {
    return _channel.invokeMethod("init", appKey);
  }

  /// Set a custom device key-value
  static Future<void> setDeviceString(String key, String value) {
    Map<String, String> map = <String, String>{
      'key': key,
      'value': value,
    };
    return _channel.invokeMethod("setDeviceString", map);
  }

  /// Set a custom device key-value
  static Future<void> setDeviceInt(String key, int value) {
    Map<String, Object> map = <String, Object>{
      'key': key,
      'value': value,
    };
    return _channel.invokeMethod("setDeviceInt", map);
  }

  /// Set a custom device key-value
  static Future<void> setDeviceFloat(String key, double value) {
    Map<String, Object> map = <String, Object>{
      'key': key,
      'value': value,
    };
    return _channel.invokeMethod("setDeviceFloat", map);
  }

  /// Set a custom device key-value
  static Future<void> setDeviceBool(String key, bool value) {
    Map<String, Object> map = <String, Object>{
      'key': key,
      'value': value,
    };
    return _channel.invokeMethod("setDeviceBool", map);
  }

  /// Remove a device key
  @Deprecated("use removeDeviceKey")
  static Future<void> removeDeviceString(String key) {
    return _channel.invokeMethod("removeDeviceKey", key);
  }

  /// Remove a device key
  static Future<void> removeDeviceKey(String key) {
    return _channel.invokeMethod("removeDeviceKey", key);
  }

  /// Send a crash to Bugfender
  static Future<Uri> sendCrash(String title, String stacktrace) {
    Map<String, String> issue = <String, String>{
      'title': title,
      'value': stacktrace,
    };
    return _channel.invokeMethod("sendCrash", issue).then((value) => Uri.parse(value));
  }

  /// Send an issue to Bugfender
  static Future<Uri> sendIssue(String title, String text) {
    Map<String, String> issue = <String, String>{
      'title': title,
      'value': '```\n' + text + '\n```',
    };
    return _channel.invokeMethod("sendIssue", issue).then((value) => Uri.parse(value));
  }

  /// Send an issue to Bugfender
  static Future<Uri> sendIssueMarkdown(String title, String markdown) {
    Map<String, String> issue = <String, String>{
      'title': title,
      'value': markdown,
    };
    return _channel.invokeMethod("sendIssue", issue).then((value) => Uri.parse(value));
  }

  /// Send an issue to Bugfender
  static Future<Uri> sendUserFeedback(String title, String markdown) {
    Map<String, String> issue = <String, String>{
      'title': title,
      'value': markdown,
    };
    return _channel.invokeMethod("sendUserFeedback", issue).then((value) => Uri.parse(value));
  }

  /// Force enable sending logs and crashes to Bugfender and remember until reverted
  static Future<void> setForceEnabled(bool enabled) {
    return _channel.invokeMethod("setForceEnabled", enabled);
  }

  /// Force enable sending logs and crashes to Bugfender, only for this session
  static Future<void> forceSendOnce() {
    return _channel.invokeMethod("forceSendOnce");
  }

  /// Gets the URL to see the logs of this device
  static Future<Uri> getDeviceUri() {
    return _channel.invokeMethod("getDeviceUri").then((value) => Uri.parse(value));
  }

  /// Gets the URL to see the logs of this session
  static Future<Uri> getSessionUri() {
    return _channel.invokeMethod("getSessionUri").then((value) => Uri.parse(value));
  }

  /// Log something.
  static Future<void> log(String value) {
    return _channel.invokeMethod("log", value);
  }

  /// Send a log with fatal level.
  static Future<void> fatal(String value) {
    return _channel.invokeMethod("fatal", value);
  }

  /// Send a log with error level.
  static Future<void> error(String value) {
    return _channel.invokeMethod("error", value);
  }

  /// Send a log with warning level.
  static Future<void> warn(String value) {
    return _channel.invokeMethod("warn", value);
  }

  /// Send a log with info level.
  static Future<void> info(String value) {
    return _channel.invokeMethod("info", value);
  }

  /// Send a log with trace level.
  static Future<void> trace(String value) {
    return _channel.invokeMethod("trace", value);
  }

  /// Send a log with debug level.
  static Future<void> debug(String value) {
    return _channel.invokeMethod("debug", value);
  }
}
