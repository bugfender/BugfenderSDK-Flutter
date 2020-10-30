package com.ninja.flutterbugfender;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.bugfender.android.BuildConfig;
import com.bugfender.sdk.Bugfender;

import android.app.Activity;

import java.net.URL;

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
                String appKey = call.argument("appKey");
                String apiUri = call.argument("apiUri");
                String baseUri = call.argument("baseUri");
                int maximumLocalStorageSize = call.argument("maximumLocalStorageSize");
                boolean printToConsole = call.argument("printToConsole");
                boolean enableUIEventLogging = call.argument("enableUIEventLogging");
                boolean enableCrashReporting = call.argument("enableCrashReporting");
                boolean enableAndroidLogcatLogging = call.argument("enableAndroidLogcatLogging");
                String overrideDeviceName = call.argument("overrideDeviceName");

                if (overrideDeviceName != "")
                    Bugfender.overrideDeviceName(overrideDeviceName);
                if (apiUri != "")
                    Bugfender.setApiUrl(apiUri);
                if (baseUri != "")
                    Bugfender.setBaseUrl(baseUri);
                Bugfender.init(activity.getApplicationContext(), appKey, printToConsole);
                if (enableAndroidLogcatLogging)
                    Bugfender.enableLogcatLogging();
                if (enableUIEventLogging)
                    Bugfender.enableUIEventLogging(activity.getApplication());
                if (enableCrashReporting)
                    Bugfender.enableCrashReporting();
                if (maximumLocalStorageSize != 0) {
                    Bugfender.setMaximumLocalStorageSize(maximumLocalStorageSize);
                }
                result.success(null);
                break;
            case "setDeviceString":
            case "setDeviceInt":
            case "setDeviceFloat":
            case "setDeviceBool":
                String key = call.argument("key");
                switch (call.method) {
                    case "setDeviceString":
                        String strvalue = call.argument("value");
                        Bugfender.setDeviceString(key, strvalue);
                        break;
                    case "setDeviceInt":
                        int intvalue = call.argument("value");
                        Bugfender.setDeviceInteger(key, intvalue);
                        break;
                    case "setDeviceFloat":
                        double floatvalue = call.argument("value");
                        Bugfender.setDeviceFloat(key, (float)floatvalue); // losing precision here: flutter's native type is a double but Bugfender only supports float
                        break;
                    case "setDeviceBool":
                        boolean boolvalue = call.argument("value");
                        Bugfender.setDeviceBoolean(key, boolvalue);
                        break;
                }
                result.success(null);
                break;
            case "removeDeviceKey":
                String key_to_remove = call.arguments();
                Bugfender.removeDeviceKey(key_to_remove);
                result.success(null);
                break;
            case "sendCrash":
            case "sendIssue":
            case "sendUserFeedback":
                String title = call.argument("title");
                String issue_val = call.argument("value");
                URL url = null;
                switch (call.method) {
                    case "sendCrash":
                        url = Bugfender.sendCrash(title, issue_val);
                        break;
                    case "sendIssue":
                        url = Bugfender.sendIssue(title, issue_val);
                        break;
                    case "sendUserFeedback":
                        url = Bugfender.sendUserFeedback(title, issue_val);
                        break;
                }
                result.success(url.toString());
                break;
            case "setForceEnabled":
                Boolean enabled = call.arguments();
                Bugfender.setForceEnabled(enabled);
                result.success(null);
                break;
            case "forceSendOnce":
                Bugfender.forceSendOnce();
                result.success(null);
                break;
            case "getDeviceUri":
                result.success(Bugfender.getDeviceUrl().toString());
                break;
            case "getSessionUri":
                result.success(Bugfender.getSessionUrl().toString());
                break;
            case "log":
            case "fatal":
            case "error":
            case "warn":
            case "info":
            case "debug":
            case "trace":
                String log = call.arguments();
                switch(call.method) {
                    case "fatal":
                        Bugfender.f("", log);
                        break;
                    case "error":
                        Bugfender.e("", log);
                        break;
                    case "warn":
                        Bugfender.w("", log);
                        break;
                    case "info":
                        Bugfender.i("", log);
                        break;
                    case "trace":
                        Bugfender.t("", log);
                        break;
                    default:
                        Bugfender.d("", log);
                        break;
                }
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
