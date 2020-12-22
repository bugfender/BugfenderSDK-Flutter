import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBugfender {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bugfender');

  /// Init Bugfender
  static Future<void> init(
    String appKey, {
    Uri? apiUri,
    Uri? baseUri,
    int? maximumLocalStorageSize,
    bool printToConsole = true,
    bool enableUIEventLogging = true,
    bool enableCrashReporting = true,
    bool enableAndroidLogcatLogging = true,
    String? overrideDeviceName,
  }) {
    Map<String, Object> map = <String, Object>{
      'appKey': appKey,
      'apiUri': apiUri != null ? apiUri.toString() : '',
      'baseUri': baseUri != null ? baseUri.toString() : '',
      'maximumLocalStorageSize': maximumLocalStorageSize ?? 0,
      'printToConsole': printToConsole,
      'enableUIEventLogging': enableUIEventLogging,
      'enableCrashReporting': enableCrashReporting,
      'enableAndroidLogcatLogging': enableAndroidLogcatLogging,
      'overrideDeviceName': overrideDeviceName ?? '',
    };
    return _channel.invokeMethod('init', map);
  }

  /// Set a custom device key-value
  static Future<void> setDeviceString(String key, String value) {
    return _channel.invokeMethod('setDeviceString', {
      'key': key,
      'value': value,
    });
  }

  /// Set a custom device key-value
  static Future<void> setDeviceInt(String key, int value) {
    return _channel.invokeMethod('setDeviceInt', {
      'key': key,
      'value': value,
    });
  }

  /// Set a custom device key-value
  static Future<void> setDeviceFloat(String key, double value) {
    return _channel.invokeMethod('setDeviceFloat', {
      'key': key,
      'value': value,
    });
  }

  /// Set a custom device key-value
  static Future<void> setDeviceBool(String key, bool value) {
    return _channel.invokeMethod('setDeviceBool', {
      'key': key,
      'value': value,
    });
  }

  /// Remove a device key
  @Deprecated('use removeDeviceKey')
  static Future<void> removeDeviceString(String key) {
    return _channel.invokeMethod('removeDeviceKey', key);
  }

  /// Remove a device key
  static Future<void> removeDeviceKey(String key) {
    return _channel.invokeMethod('removeDeviceKey', key);
  }

  /// Send a crash to Bugfender
  static Future<Uri> sendCrash(String title, String stacktrace) {
    return _channel.invokeMethod('sendCrash', {
      'title': title,
      'value': stacktrace,
    }).then((value) => Uri.parse(value));
  }

  /// Send an issue to Bugfender
  static Future<Uri> sendIssue(String title, String text) {
    return _channel.invokeMethod('sendIssue', {
      'title': title,
      'value': '```\n' + text + '\n```',
    }).then((value) => Uri.parse(value));
  }

  /// Send an issue to Bugfender
  static Future<Uri> sendIssueMarkdown(String title, String markdown) {
    return _channel.invokeMethod('sendIssue', {
      'title': title,
      'value': markdown,
    }).then((value) => Uri.parse(value));
  }

  /// Send an issue to Bugfender
  static Future<Uri> sendUserFeedback(String title, String markdown) {
    return _channel.invokeMethod('sendUserFeedback', {
      'title': title,
      'value': markdown,
    }).then((value) => Uri.parse(value));
  }

  /// Force enable sending logs and crashes to Bugfender and remember until reverted
  static Future<void> setForceEnabled(bool enabled) {
    return _channel.invokeMethod('setForceEnabled', enabled);
  }

  /// Force enable sending logs and crashes to Bugfender, only for this session
  static Future<void> forceSendOnce() {
    return _channel.invokeMethod('forceSendOnce');
  }

  /// Gets the URL to see the logs of this device
  static Future<Uri> getDeviceUri() {
    return _channel
        .invokeMethod('getDeviceUri')
        .then((value) => Uri.parse(value));
  }

  /// Gets the URL to see the logs of this session
  static Future<Uri> getSessionUri() {
    return _channel
        .invokeMethod('getSessionUri')
        .then((value) => Uri.parse(value));
  }

  /// Log something.
  static Future<void> log(String value) {
    return _channel.invokeMethod('log', value);
  }

  /// Send a log with fatal level.
  static Future<void> fatal(String value) {
    return _channel.invokeMethod('fatal', value);
  }

  /// Send a log with error level.
  static Future<void> error(String value) {
    return _channel.invokeMethod('error', value);
  }

  /// Send a log with warning level.
  static Future<void> warn(String value) {
    return _channel.invokeMethod('warn', value);
  }

  /// Send a log with info level.
  static Future<void> info(String value) {
    return _channel.invokeMethod('info', value);
  }

  /// Send a log with trace level.
  static Future<void> trace(String value) {
    return _channel.invokeMethod('trace', value);
  }

  /// Send a log with debug level.
  static Future<void> debug(String value) {
    return _channel.invokeMethod('debug', value);
  }
}
