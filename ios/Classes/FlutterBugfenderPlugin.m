#import "FlutterBugfenderPlugin.h"
@import BugfenderSDK;

@implementation FlutterBugfenderPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"flutter_bugfender"
                  binaryMessenger:[registrar messenger]];
    FlutterBugfenderPlugin *instance = [[FlutterBugfenderPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        NSString *appKey = call.arguments;
        [Bugfender activateLogger:appKey];
        [Bugfender enableUIEventLogging];
        [Bugfender enableCrashReporting];
        result(nil);
    } else if ([@"setDeviceString" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *key = arguments[@"key"];
        NSString *value = arguments[@"value"];
        [Bugfender setDeviceString:value forKey:key];
        result(nil);
    } else if ([@"setDeviceInt" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *key = arguments[@"key"];
        NSInteger value = [arguments[@"value"] integerValue];
        [Bugfender setDeviceInteger:value forKey:key];
        result(nil);
    } else if ([@"setDeviceFloat" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *key = arguments[@"key"];
        CGFloat value = [arguments[@"value"] floatValue];
        [Bugfender setDeviceDouble:value forKey:key];
        result(nil);
    } else if ([@"setDeviceBool" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *key = arguments[@"key"];
        BOOL value = [arguments[@"value"] boolValue];
        [Bugfender setDeviceBOOL:value forKey:key];
        result(nil);
    } else if ([@"removeDeviceKey" isEqualToString:call.method]) {
        NSString *key = call.arguments;
        [Bugfender removeDeviceKey:key];
        result(nil);
    } else if ([@"setForceEnabled" isEqualToString:call.method]) {
        NSString *key = call.arguments;
        [Bugfender setForceEnabled:key];
        result(nil);
    } else if ([@"forceSendOnce" isEqualToString:call.method]) {
        [Bugfender forceSendOnce];
        result(nil);
    } else if ([@"sendCrash" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *title = arguments[@"title"];
        NSString *value = arguments[@"value"];
        NSURL* url = [Bugfender sendCrashWithTitle:title text:value];
        result(url.absoluteString);
    } else if ([@"sendIssue" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *title = arguments[@"title"];
        NSString *value = arguments[@"value"];
        NSURL* url = [Bugfender sendIssueReturningUrlWithTitle:title text:value];
        result(url.absoluteString);
    } else if ([@"sendUserFeedback" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *title = arguments[@"title"];
        NSString *value = arguments[@"value"];
        NSURL* url = [Bugfender sendUserFeedbackReturningUrlWithSubject:title message:value];
        result(url.absoluteString);
    } else if ([@"getDeviceUri" isEqualToString:call.method]) {
        NSURL* url = [Bugfender deviceIdentifierUrl];
        result(url.absoluteString);
    } else if ([@"getSessionUri" isEqualToString:call.method]) {
        NSURL* url = [Bugfender sessionIdentifierUrl];
        result(url.absoluteString);
    } else if ([@"log" isEqualToString:call.method]) {
        BFLog (@"%@", call.arguments);
        result(nil);
    } else if ([@"fatal" isEqualToString:call.method]) {
        BFLogFatal(@"%@", call.arguments);
        result(nil);
    } else if ([@"error" isEqualToString:call.method]) {
        BFLogErr(@"%@", call.arguments);
        result(nil);
    } else if ([@"warn" isEqualToString:call.method]) {
        BFLogWarn(@"%@", call.arguments);
        result(nil);
    } else if ([@"info" isEqualToString:call.method]) {
        BFLogInfo(@"%@", call.arguments);
        result(nil);
    } else if ([@"debug" isEqualToString:call.method]) {
        BFLog(@"%@", call.arguments);
        result(nil);
    } else if ([@"trace" isEqualToString:call.method]) {
        BFLogTrace(@"%@", call.arguments);
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
