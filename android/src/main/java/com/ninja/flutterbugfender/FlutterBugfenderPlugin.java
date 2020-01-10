package com.ninja.flutterbugfender;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.bugfender.sdk.Bugfender;
import com.bugfender.sdk.LogLevel;

import android.app.Activity;

/**
 * FlutterBugfenderPlugin
 */
public class FlutterBugfenderPlugin implements MethodCallHandler {

    private final Activity activity;

    private FlutterBugfenderPlugin(Activity activity) {
        this.activity = activity;
    }


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_bugfender");
        channel.setMethodCallHandler(new FlutterBugfenderPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "init":
                String appKey = call.arguments();
                Bugfender.init(activity.getApplicationContext(), appKey, BuildConfig.DEBUG);
//                Bugfender.enableLogcatLogging();
//                Bugfender.enableUIEventLogging(activity.getApplication());
                result.success(null);
                break;
            case "setDeviceString":
                String key = call.argument("key");
                String value = call.argument("value");
                Bugfender.setDeviceString(key, value);
                result.success(null);
                break;
            case "removeDeviceString":
                String key_to_remove = call.arguments();
                Bugfender.removeDeviceKey(key_to_remove);
                result.success(null);
                break;
            case "sendIssue":
                String title = call.argument("title");
                String issue_val = call.argument("value");
                Bugfender.sendIssue(title, issue_val);
                result.success(null);
                break;
            case "log":
                String info = call.argument("log");
                String tagInfo = call.argument("tag");
                Bugfender.d(tagInfo, info);
                result.success(null);
                break;
            case "logExtended":
                String log = call.argument("log");
                String tag = call.argument("tag");
                String methodName = call.argument("methodName");
                String className = call.argument("className");
                String level = call.argument("logLevel");
                LogLevel logLevel = LogLevel.valueOf(level);
                Bugfender.log(0, methodName, className, logLevel, tag, log);
                result.success(null);
                break;
            case "warn":
                String warn = call.argument("log");
                String tagWarn = call.argument("tag");
                Bugfender.w(tagWarn, warn);
                result.success(null);
                break;
            case "error":
                String err = call.argument("log");
                String tagErr = call.argument("tag");
                Bugfender.e(tagErr, err);
                result.success(null);
                break;
            case "forceSendOnce":
                Bugfender.forceSendOnce();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
