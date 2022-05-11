import 'package:flutter_bugfender/flutter_bugfender_method_channel.dart';
import 'package:meta/meta.dart';

abstract class FlutterBugfenderInterface {
  static FlutterBugfenderInterface _instance = MethodChannelFlutterBugfender();

  static FlutterBugfenderInterface get instance => _instance;

  static set instance(FlutterBugfenderInterface instance) {
    if (!instance.isMock) {
      instance._verifyProvidesDefaultImplementations();
    }
    _instance = instance;
  }

  Future<void> init(
    String appKey, {
    Uri? apiUri,
    Uri? baseUri,
    int? maximumLocalStorageSize,
    bool printToConsole = true,
    bool enableUIEventLogging = true,
    bool enableCrashReporting = true,
    bool enableAndroidLogcatLogging = true,
    String? overrideDeviceName,
    String? version,
    String? build,
  }) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> setDeviceString(String key, String value) {
    throw UnimplementedError('setDeviceString() has not been implemented.');
  }

  Future<void> setDeviceInt(String key, int value) {
    throw UnimplementedError('setDeviceInt() has not been implemented.');
  }

  Future<void> setDeviceFloat(String key, double value) {
    throw UnimplementedError('setDeviceFloat() has not been implemented.');
  }

  Future<void> setDeviceBool(String key, bool value) {
    throw UnimplementedError('setDeviceBool() has not been implemented.');
  }

  Future<void> removeDeviceKey(String key) {
    throw UnimplementedError('removeDeviceKey() has not been implemented.');
  }

  Future<Uri> sendCrash(String title, String stacktrace) {
    throw UnimplementedError('sendCrash() has not been implemented.');
  }

  Future<Uri> sendIssue(String title, String text) {
    throw UnimplementedError('sendIssue() has not been implemented.');
  }

  Future<Uri> sendIssueMarkdown(String title, String markdown) {
    throw UnimplementedError('sendIssueMarkdown() has not been implemented.');
  }

  Future<Uri> sendUserFeedback(String title, String text) {
    throw UnimplementedError('sendUserFeedback() has not been implemented.');
  }

  Future<void> setForceEnabled(bool enabled) {
    throw UnimplementedError('setForceEnabled() has not been implemented.');
  }

  Future<void> forceSendOnce() {
    throw UnimplementedError('forceSendOnce() has not been implemented.');
  }

  Future<Uri> getDeviceUri() {
    throw UnimplementedError('getDeviceUri() has not been implemented.');
  }

  Future<Uri> getSessionUri() {
    throw UnimplementedError('getSessionUri() has not been implemented.');
  }

  Future<void> log(String value) {
    throw UnimplementedError('log() has not been implemented.');
  }

  Future<void> fatal(String value) {
    throw UnimplementedError('fatal() has not been implemented.');
  }

  Future<void> error(String value) {
    throw UnimplementedError('error() has not been implemented.');
  }

  Future<void> warn(String value) {
    throw UnimplementedError('warn() has not been implemented.');
  }

  Future<void> info(String value) {
    throw UnimplementedError('info() has not been implemented.');
  }

  Future<void> trace(String value) {
    throw UnimplementedError('trace() has not been implemented.');
  }

  Future<void> debug(String value) {
    throw UnimplementedError('debug() has not been implemented.');
  }

  Future<Uri?> getUserFeedback(
      {String title = "Feedback",
      String hint = "Please insert your feedback here and click send",
      String subjectHint = "Subject…",
      String messageHint = "Your feedback…",
      String sendButtonText = "Send",
      String cancelButtonText = "Close"}) {
    throw UnimplementedError(
        'getUserFeedback() has not been implemented');
  }

  @visibleForTesting
  bool get isMock => false;

  void _verifyProvidesDefaultImplementations() {}
}
