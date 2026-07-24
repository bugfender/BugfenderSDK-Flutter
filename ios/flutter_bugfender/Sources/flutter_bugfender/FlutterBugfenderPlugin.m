#import "./include/flutter_bugfender/FlutterBugfenderPlugin.h"
@import BugfenderSDK;

@interface FlutterBugfenderPlugin ()
@property(nonatomic, strong) FlutterMethodChannel *channel;
@end

@implementation FlutterBugfenderPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"flutter_bugfender"
                  binaryMessenger:[registrar messenger]];
    FlutterBugfenderPlugin *instance = [[FlutterBugfenderPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (BFLogLevel)intToLogLevel:(int) logLevelIndex {
    switch (logLevelIndex) {
        case 0:
            return BFLogLevelTrace;
            break;
        case 1:
            return BFLogLevelDefault;
            break;
        case 2:
            return BFLogLevelInfo;
            break;
        case 3:
            return BFLogLevelWarning;
            break;
        case 4:
            return BFLogLevelError;
            break;
        case 5:
            return BFLogLevelFatal;
            break;
        default:
            return BFLogLevelDefault;
            break;
    }
}

- (NSDictionary *)invokeDartObfuscation:(NSString *)method arguments:(NSDictionary *)arguments {
    if (self.channel == nil) {
        return nil;
    }

    // Avoid deadlocking the platform/UI thread while waiting for Dart.
    if ([NSThread isMainThread]) {
        return nil;
    }

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response = nil;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:method
                         arguments:arguments
                            result:^(id _Nullable result) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                response = result;
            }
            dispatch_semaphore_signal(semaphore);
        }];
    });

    long waitResult = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)));
    if (waitResult != 0) {
        return nil;
    }
    return response;
}

- (NSDictionary<NSString *, NSString *> *)stringMapFrom:(id)value {
    NSMutableDictionary<NSString *, NSString *> *mapped = [NSMutableDictionary dictionary];
    if (![value isKindOfClass:[NSDictionary class]]) {
        return mapped;
    }
    NSDictionary *raw = (NSDictionary *)value;
    for (id key in raw) {
        id entry = raw[key];
        mapped[[key description]] = entry == [NSNull null] || entry == nil ? @"" : [entry description];
    }
    return mapped;
}

- (void)installRequestObfuscationHandler {
    __weak FlutterBugfenderPlugin *weakSelf = self;
    [Bugfender setNetworkLoggingRequestObfuscationHandler:^BFNetworkRequestData * _Nonnull(NSString * _Nonnull url, NSDictionary<NSString *,NSString *> * _Nonnull headers, NSString * _Nullable body) {
        FlutterBugfenderPlugin *strongSelf = weakSelf;
        if (strongSelf == nil) {
            return [[BFNetworkRequestData alloc] initWithURL:url headers:headers body:body];
        }

        NSDictionary *response = [strongSelf invokeDartObfuscation:@"obfuscateNetworkRequest"
                                                         arguments:@{
            @"url": url ?: @"",
            @"headers": headers ?: @{},
            @"body": body ?: [NSNull null],
        }];
        if (response == nil) {
            return [[BFNetworkRequestData alloc] initWithURL:url headers:headers body:body];
        }

        NSString *obfuscatedUrl = [response[@"url"] isKindOfClass:[NSString class]] ? response[@"url"] : url;
        NSDictionary<NSString *, NSString *> *obfuscatedHeaders = [strongSelf stringMapFrom:response[@"headers"]];
        NSString *obfuscatedBody = nil;
        if ([response[@"body"] isKindOfClass:[NSString class]]) {
            obfuscatedBody = response[@"body"];
        } else if (response[@"body"] == [NSNull null] || response[@"body"] == nil) {
            obfuscatedBody = nil;
        }
        return [[BFNetworkRequestData alloc] initWithURL:obfuscatedUrl headers:obfuscatedHeaders body:obfuscatedBody];
    }];
}

- (void)installResponseObfuscationHandler {
    __weak FlutterBugfenderPlugin *weakSelf = self;
    [Bugfender setNetworkLoggingResponseObfuscationHandler:^BFNetworkResponseData * _Nonnull(NSDictionary<NSString *,NSString *> * _Nonnull headers, NSString * _Nullable body) {
        FlutterBugfenderPlugin *strongSelf = weakSelf;
        if (strongSelf == nil) {
            return [[BFNetworkResponseData alloc] initWithHeaders:headers body:body];
        }

        NSDictionary *response = [strongSelf invokeDartObfuscation:@"obfuscateNetworkResponse"
                                                         arguments:@{
            @"headers": headers ?: @{},
            @"body": body ?: [NSNull null],
        }];
        if (response == nil) {
            return [[BFNetworkResponseData alloc] initWithHeaders:headers body:body];
        }

        NSDictionary<NSString *, NSString *> *obfuscatedHeaders = [strongSelf stringMapFrom:response[@"headers"]];
        NSString *obfuscatedBody = nil;
        if ([response[@"body"] isKindOfClass:[NSString class]]) {
            obfuscatedBody = response[@"body"];
        }
        return [[BFNetworkResponseData alloc] initWithHeaders:obfuscatedHeaders body:obfuscatedBody];
    }];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"appKey"];
        NSString *apiUri = call.arguments[@"apiUri"];
        NSString *baseUri = call.arguments[@"baseUri"];
        long maximumLocalStorageSize = [call.arguments[@"maximumLocalStorageSize"] longValue];
        BOOL printToConsole = [call.arguments[@"printToConsole"] boolValue];
        BOOL enableUIEventLogging = [call.arguments[@"enableUIEventLogging"] boolValue];
        BOOL enableCrashReporting = [call.arguments[@"enableCrashReporting"] boolValue];
        NSString *overrideDeviceName = call.arguments[@"overrideDeviceName"];

        if (overrideDeviceName.length)
            [Bugfender overrideDeviceName:overrideDeviceName];
        if (apiUri.length)
            [Bugfender setApiURL:[NSURL URLWithString:apiUri]];
        if (baseUri.length)
            [Bugfender setBaseURL:[NSURL URLWithString:baseUri]];
        [Bugfender activateLogger:appKey];
        if (enableUIEventLogging)
            [Bugfender enableUIEventLogging];
        if (enableCrashReporting)
            [Bugfender enableCrashReporting];
        [Bugfender setPrintToConsole:printToConsole];
        if (maximumLocalStorageSize) {
            [Bugfender setMaximumLocalStorageSize:maximumLocalStorageSize];
        }
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
        BOOL enable = [call.arguments boolValue];
        [Bugfender setForceEnabled:enable];
        result(nil);
    } else if ([@"setSDKType" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *sdkName = arguments[@"sdkName"];
        NSNumber *sdkVersion = arguments[@"sdkVersion"];
        [Bugfender setSDKType:sdkName version:[sdkVersion integerValue]];
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
    } else if ([@"sendLog" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *lineNumber = arguments[@"line"];
        NSString *method = arguments[@"method"];
        NSString *file = arguments[@"file"];
        NSString *levelOrdinal = arguments[@"level"];
        NSString *tag = arguments[@"tag"];
        NSString *text = arguments[@"text"];
        [Bugfender logWithLineNumber: [lineNumber integerValue] method: method file: file level: [self intToLogLevel: [levelOrdinal integerValue]] tag: tag message: text];
        result(nil);
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
    } else if ([@"getUserFeedback" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *title = arguments[@"title"];
        NSString *hint = arguments[@"hint"];
        NSString *subjectHint = arguments[@"subjectHint"];
        NSString *messageHint = arguments[@"messageHint"];
        NSString *sendButtonText = arguments[@"sendButtonText"];
        NSString *cancelButtonText = arguments[@"cancelButtonText"];

        UIViewController * userFeedbackViewController = [Bugfender userFeedbackViewControllerWithTitle:title hint:hint subjectPlaceholder:subjectHint
        messagePlaceholder:messageHint sendButtonTitle:sendButtonText cancelButtonTitle:cancelButtonText completion:^(BOOL feedbackSent, NSURL * _Nullable url) {
            if (feedbackSent) {
                result(url.absoluteString);
            } else {
                result(nil);
            }
        }];
        userFeedbackViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        UIViewController* rootViewController = [[[[UIApplication sharedApplication]delegate] window] rootViewController];
        [rootViewController presentViewController:userFeedbackViewController animated:YES completion:nil];
    } else if ([@"setNetworkLoggingEnabled" isEqualToString:call.method]) {
        [Bugfender setNetworkLoggingEnabled:[call.arguments boolValue]];
        result(nil);
    } else if ([@"setNetworkLoggingCaptureBodies" isEqualToString:call.method]) {
        [Bugfender setNetworkLoggingCaptureBodies:[call.arguments boolValue]];
        result(nil);
    } else if ([@"setNetworkLoggingCaptureErrorResponseBodies" isEqualToString:call.method]) {
        [Bugfender setNetworkLoggingCaptureErrorResponseBodies:[call.arguments boolValue]];
        result(nil);
    } else if ([@"setNetworkLoggingURLFilter" isEqualToString:call.method]) {
        NSDictionary *arguments = [call.arguments isKindOfClass:[NSDictionary class]] ? call.arguments : @{};
        id allowlist = arguments[@"allowlist"];
        id denylist = arguments[@"denylist"];
        if (allowlist == [NSNull null] || ![allowlist isKindOfClass:[NSArray class]]) {
            allowlist = nil;
        }
        if (denylist == [NSNull null] || ![denylist isKindOfClass:[NSArray class]]) {
            denylist = nil;
        }
        [Bugfender setNetworkLoggingURLFilterWithAllowlist:allowlist
                                                  denylist:denylist];
        result(nil);
    } else if ([@"setNetworkLoggingMaxRequestsPerMinute" isEqualToString:call.method]) {
        id arguments = call.arguments;
        if (arguments == nil || arguments == [NSNull null]) {
            [Bugfender setNetworkLoggingMaxRequestsPerMinute:nil];
        } else {
            [Bugfender setNetworkLoggingMaxRequestsPerMinute:arguments];
        }
        result(nil);
    } else if ([@"setNetworkLoggingRequestObfuscationHandlerEnabled" isEqualToString:call.method]) {
        if ([call.arguments boolValue]) {
            [self installRequestObfuscationHandler];
        } else {
            [Bugfender setNetworkLoggingRequestObfuscationHandler:nil];
        }
        result(nil);
    } else if ([@"setNetworkLoggingResponseObfuscationHandlerEnabled" isEqualToString:call.method]) {
        if ([call.arguments boolValue]) {
            [self installResponseObfuscationHandler];
        } else {
            [Bugfender setNetworkLoggingResponseObfuscationHandler:nil];
        }
        result(nil);
    } else if ([@"sendInstrumentedNetworkRequest" isEqualToString:call.method]) {
        NSDictionary *arguments = [call.arguments isKindOfClass:[NSDictionary class]] ? call.arguments : @{};
        NSString *urlString = [arguments[@"url"] isKindOfClass:[NSString class]] ? arguments[@"url"] : @"https://example.com/";
        NSString *httpMethod = [arguments[@"method"] isKindOfClass:[NSString class]] ? [arguments[@"method"] uppercaseString] : @"GET";
        NSString *body = [arguments[@"body"] isKindOfClass:[NSString class]] ? arguments[@"body"] : nil;
        NSDictionary *extraHeaders = [arguments[@"headers"] isKindOfClass:[NSDictionary class]] ? arguments[@"headers"] : @{};

        NSURL *url = [NSURL URLWithString:urlString];
        if (url == nil) {
            result([FlutterError errorWithCode:@"bad_url" message:@"Invalid URL" details:urlString]);
            return;
        }

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = httpMethod;
        request.timeoutInterval = 15.0;
        BOOL hasAuthorization = NO;
        for (NSString *key in extraHeaders) {
            id value = extraHeaders[key];
            if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [request setValue:(NSString *)value forHTTPHeaderField:key];
                if ([key caseInsensitiveCompare:@"Authorization"] == NSOrderedSame) {
                    hasAuthorization = YES;
                }
            }
        }
        if (!hasAuthorization) {
            [request setValue:@"secret-token" forHTTPHeaderField:@"Authorization"];
        }
        if (body.length > 0 && ([httpMethod isEqualToString:@"POST"] || [httpMethod isEqualToString:@"PUT"] || [httpMethod isEqualToString:@"PATCH"])) {
            [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                result([FlutterError errorWithCode:@"network_error" message:error.localizedDescription details:nil]);
                return;
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSInteger status = [httpResponse isKindOfClass:[NSHTTPURLResponse class]] ? httpResponse.statusCode : 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [Bugfender forceSendOnce];
                result(@{
                    @"status": @(status),
                    @"shouldCapture": @YES,
                    @"requestId": [NSNull null],
                });
            });
        }];
        [task resume];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
