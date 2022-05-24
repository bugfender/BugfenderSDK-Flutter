package com.bugfender.flutterbugfender;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.bugfender.sdk.Bugfender;
import com.bugfender.sdk.LogLevel;
import com.bugfender.sdk.ui.FeedbackActivity;

import java.net.URL;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterBugfenderPlugin
 */
public class FlutterBugfenderPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private Context applicationContext;
    private Activity activity;
    private ActivityPluginBinding activityPluginBinding;

    private static final int FEEDBACK_REQUEST_CODE = 9564;

    private MethodChannel.Result feedbackScreenPendingResult;
    private final PluginRegistry.ActivityResultListener feedbackActivityResultListener = new PluginRegistry.ActivityResultListener() {
        @Override
        public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
            if (feedbackScreenPendingResult != null) {
                if (requestCode == FEEDBACK_REQUEST_CODE) {
                    if (resultCode == Activity.RESULT_OK) {
                        feedbackScreenPendingResult.success(data.getExtras().getString(FeedbackActivity.RESULT_FEEDBACK_URL));
                    } else {
                        feedbackScreenPendingResult.success(null);
                    }
                }
                return true;
            }
            return false;
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_bugfender");
        channel.setMethodCallHandler(this);
        applicationContext = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        applicationContext = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
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

                if (!Objects.equals(overrideDeviceName, "")) {
                    Bugfender.overrideDeviceName(overrideDeviceName);
                }
                if (!Objects.equals(apiUri, "")) {
                    Bugfender.setApiUrl(apiUri);
                }
                if (!Objects.equals(baseUri, "")) {
                    Bugfender.setBaseUrl(baseUri);
                }
                Bugfender.init(applicationContext, appKey, printToConsole);
                if (enableAndroidLogcatLogging) {
                    Bugfender.enableLogcatLogging();
                }
                if (enableUIEventLogging) {
                    Bugfender.enableUIEventLogging(((Application) applicationContext));
                }
                if (enableCrashReporting) {
                    Bugfender.enableCrashReporting();
                }
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
                        Bugfender.setDeviceFloat(key, (float) floatvalue); // losing precision here: flutter's native type is a double but Bugfender only supports float
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
            case "sendLog":
                int lineNumber = call.argument("line");
                String method = call.argument("method");
                String file = call.argument("file");
                int levelOrdinal = call.argument("level");
                LogLevel level = LogLevel.values()[levelOrdinal];
                String tag = call.argument("tag");
                String text = call.argument("text");
                Bugfender.log(lineNumber, method, file, level, tag, text);
                result.success(null);
                break;
            case "log":
            case "fatal":
            case "error":
            case "warn":
            case "info":
            case "debug":
            case "trace":
                String log = call.arguments();
                switch (call.method) {
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
            case "getUserFeedback":
                String feedbackTitle = call.argument("title");
                String feedbackHint = call.argument("hint");
                String feedbackSubjectHint = call.argument("subjectHint");
                String feedbackMessageHint = call.argument("messageHint");
                String feedbackSendButtonText = call.argument("sendButtonText");
                this.feedbackScreenPendingResult = result;
                activity.startActivityForResult(
                        Bugfender.getUserFeedbackActivityIntent(
                                activity,
                                feedbackTitle,
                                feedbackHint,
                                feedbackSubjectHint,
                                feedbackMessageHint,
                                feedbackSendButtonText,
                                null
                        ),
                        FEEDBACK_REQUEST_CODE
                );
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        activity = activityPluginBinding.getActivity();
        addActivityResultListener(activityPluginBinding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
        removeActivityResultListener();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
        activity = activityPluginBinding.getActivity();
        addActivityResultListener(activityPluginBinding);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        removeActivityResultListener();
    }

    private void addActivityResultListener(ActivityPluginBinding activityPluginBinding) {
        activityPluginBinding.addActivityResultListener(feedbackActivityResultListener);
        this.activityPluginBinding = activityPluginBinding;
    }

    private void removeActivityResultListener() {
        activityPluginBinding.removeActivityResultListener(feedbackActivityResultListener);
        activityPluginBinding = null;
    }
}
