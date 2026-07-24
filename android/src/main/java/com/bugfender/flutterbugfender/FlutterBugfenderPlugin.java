package com.bugfender.flutterbugfender;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.bugfender.sdk.Bugfender;
import com.bugfender.sdk.BugfenderOkHttpInterceptor;
import com.bugfender.sdk.LogLevel;
import com.bugfender.sdk.ui.FeedbackActivity;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

/**
 * FlutterBugfenderPlugin
 */
public class FlutterBugfenderPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private Context applicationContext;
    private Activity activity;
    private ActivityPluginBinding activityPluginBinding;
    private MethodChannel channel;
    private final ExecutorService backgroundExecutor = Executors.newCachedThreadPool();

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
        channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_bugfender");
        channel.setMethodCallHandler(this);
        applicationContext = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
            channel = null;
        }
        applicationContext = null;
        setObfuscationHandler("setNetworkLoggingRequestObfuscationHandler", null);
        setObfuscationHandler("setNetworkLoggingResponseObfuscationHandler", null);
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
            case "setSDKType":
                String sdkName = call.argument("sdkName");
                Integer sdkVersion = call.argument("sdkVersion");
                Bugfender.setSDKType(sdkName, sdkVersion);
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
            case "setNetworkLoggingEnabled":
                Bugfender.setNetworkLoggingEnabled((Boolean) call.arguments());
                result.success(null);
                break;
            case "setNetworkLoggingCaptureBodies":
                Bugfender.setNetworkLoggingCaptureBodies((Boolean) call.arguments());
                result.success(null);
                break;
            case "setNetworkLoggingCaptureErrorResponseBodies":
                Bugfender.setNetworkLoggingCaptureErrorResponseBodies((Boolean) call.arguments());
                result.success(null);
                break;
            case "setNetworkLoggingURLFilter":
                Bugfender.setNetworkLoggingURLFilter(
                        call.argument("allowlist"),
                        call.argument("denylist")
                );
                result.success(null);
                break;
            case "setNetworkLoggingMaxRequestsPerMinute":
                Bugfender.setNetworkLoggingMaxRequestsPerMinute(call.arguments());
                result.success(null);
                break;
            case "setNetworkLoggingRequestObfuscationHandlerEnabled":
                Boolean requestEnabled = call.arguments();
                setObfuscationHandler(
                        "setNetworkLoggingRequestObfuscationHandler",
                        Boolean.TRUE.equals(requestEnabled) ? createRequestObfuscationHandler() : null
                );
                result.success(null);
                break;
            case "setNetworkLoggingResponseObfuscationHandlerEnabled":
                Boolean responseEnabled = call.arguments();
                setObfuscationHandler(
                        "setNetworkLoggingResponseObfuscationHandler",
                        Boolean.TRUE.equals(responseEnabled) ? createResponseObfuscationHandler() : null
                );
                result.success(null);
                break;
            case "sendInstrumentedNetworkRequest": {
                final Map<String, Object> args;
                if (call.arguments() instanceof Map) {
                    args = (Map<String, Object>) call.arguments();
                } else if (call.arguments() instanceof String) {
                    args = new HashMap<>();
                    args.put("url", call.arguments());
                } else {
                    args = new HashMap<>();
                    args.put("url", "https://example.com/");
                }
                backgroundExecutor.execute(() -> {
                    String requestUrl = args.get("url") instanceof String
                            ? (String) args.get("url")
                            : "https://example.com/";
                    String httpMethod = args.get("method") instanceof String
                            ? ((String) args.get("method")).toUpperCase()
                            : "GET";
                    String body = args.get("body") instanceof String ? (String) args.get("body") : null;
                    Map<String, String> extraHeaders = new HashMap<>();
                    if (args.get("headers") instanceof Map) {
                        Map<?, ?> raw = (Map<?, ?>) args.get("headers");
                        for (Map.Entry<?, ?> entry : raw.entrySet()) {
                            if (entry.getKey() != null && entry.getValue() != null) {
                                extraHeaders.put(
                                        String.valueOf(entry.getKey()),
                                        String.valueOf(entry.getValue())
                                );
                            }
                        }
                    }
                    try {
                        boolean shouldCapture = false;
                        try {
                            Method captureMethod = Bugfender.class.getDeclaredMethod(
                                    "shouldCaptureNetworkRequestInternal", String.class);
                            captureMethod.setAccessible(true);
                            Object value = captureMethod.invoke(null, requestUrl);
                            shouldCapture = value instanceof Boolean && (Boolean) value;
                        } catch (Exception ignored) {
                        }
                        android.util.Log.i(
                                "BF/FlutterNet",
                                "shouldCapture=" + shouldCapture
                                        + " method=" + httpMethod
                                        + " url=" + requestUrl
                        );

                        OkHttpClient client = new OkHttpClient.Builder()
                                .connectTimeout(15, TimeUnit.SECONDS)
                                .readTimeout(15, TimeUnit.SECONDS)
                                .writeTimeout(15, TimeUnit.SECONDS)
                                .addInterceptor(new BugfenderOkHttpInterceptor())
                                .eventListenerFactory(new com.bugfender.sdk.BugfenderOkHttpEventListenerFactory())
                                .build();

                        Request.Builder requestBuilder = new Request.Builder().url(requestUrl);
                        if (!extraHeaders.containsKey("Authorization")
                                && !extraHeaders.containsKey("authorization")) {
                            requestBuilder.header("Authorization", "secret-token");
                        }
                        for (Map.Entry<String, String> header : extraHeaders.entrySet()) {
                            requestBuilder.header(header.getKey(), header.getValue());
                        }
                        if ("POST".equals(httpMethod) || "PUT".equals(httpMethod) || "PATCH".equals(httpMethod)) {
                            okhttp3.RequestBody requestBody = okhttp3.RequestBody.create(
                                    body != null ? body : "{}",
                                    okhttp3.MediaType.parse("application/json; charset=utf-8")
                            );
                            requestBuilder.method(httpMethod, requestBody);
                        } else {
                            requestBuilder.method(httpMethod, null);
                        }

                        try (Response response = client.newCall(requestBuilder.build()).execute()) {
                            final int code = response.code();
                            String reqId = response.request().header("X-Bugfender-Request-ID");
                            String sessionId = response.request().header("X-Bugfender-Session-ID");
                            android.util.Log.i(
                                    "BF/FlutterNet",
                                    "okhttp status=" + code
                                            + " reqId=" + reqId
                                            + " sessionId=" + sessionId
                            );
                            Bugfender.d(
                                    "bf_flutter_debug",
                                    "okhttp status=" + code
                                            + " shouldCapture=" + shouldCapture
                                            + " url=" + requestUrl
                                            + " reqId=" + reqId
                            );
                            Bugfender.forceSendOnce();
                            final Map<String, Object> payload = new HashMap<>();
                            payload.put("status", code);
                            payload.put("shouldCapture", shouldCapture);
                            payload.put("requestId", reqId);
                            new android.os.Handler(android.os.Looper.getMainLooper()).post(
                                    () -> result.success(payload)
                            );
                        }
                    } catch (Exception e) {
                        android.util.Log.e("BF/FlutterNet", "okhttp failed", e);
                        try {
                            Bugfender.forceSendOnce();
                        } catch (Exception ignored) {
                        }
                        new android.os.Handler(android.os.Looper.getMainLooper()).post(
                                () -> result.error("network_error", e.getMessage(), null)
                        );
                    }
                });
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    private void setObfuscationHandler(String methodName, Object handler) {
        try {
            Method setter = findBugfenderMethod(methodName, 1);
            if (setter == null) {
                return;
            }
            setter.invoke(null, handler);
        } catch (Exception ignored) {
            // Optional API; ignore if unavailable.
        }
    }

    private static Method findBugfenderMethod(String name, int paramCount) {
        for (Method method : Bugfender.class.getMethods()) {
            if (name.equals(method.getName()) && method.getParameterTypes().length == paramCount) {
                return method;
            }
        }
        return null;
    }

    private Object createRequestObfuscationHandler() {
        Method setter = findBugfenderMethod("setNetworkLoggingRequestObfuscationHandler", 1);
        if (setter == null) {
            return null;
        }
        Class<?> handlerType = setter.getParameterTypes()[0];
        return Proxy.newProxyInstance(
                handlerType.getClassLoader(),
                new Class<?>[]{handlerType},
                (proxy, method, methodArgs) -> {
                    if (method.getDeclaringClass() == Object.class) {
                        return invokeObjectMethod(proxy, method, methodArgs);
                    }
                    if (methodArgs == null || methodArgs.length < 3) {
                        return null;
                    }
                    String url = methodArgs[0] instanceof String ? (String) methodArgs[0] : "";
                    @SuppressWarnings("unchecked")
                    Map<String, String> headers = methodArgs[1] instanceof Map
                            ? (Map<String, String>) methodArgs[1]
                            : new HashMap<>();
                    String body = methodArgs[2] instanceof String ? (String) methodArgs[2] : null;

                    Map<String, Object> args = new HashMap<>();
                    args.put("url", url != null ? url : "");
                    args.put("headers", headers != null ? new HashMap<>(headers) : new HashMap<String, String>());
                    args.put("body", body);

                    android.util.Log.i("BF/FlutterNet", "request obfuscation invoked url=" + url);
                    Map<String, Object> response = invokeDartObfuscation("obfuscateNetworkRequest", args);
                    String obfuscatedUrl = url;
                    Map<String, String> obfuscatedHeaders = headers;
                    String obfuscatedBody = body;
                    if (response != null) {
                        obfuscatedUrl = response.get("url") instanceof String ? (String) response.get("url") : url;
                        obfuscatedHeaders = toStringMap(response.get("headers"));
                        obfuscatedBody = response.get("body") instanceof String ? (String) response.get("body") : null;
                    }
                    return newNetworkData(method.getReturnType(), obfuscatedUrl, obfuscatedHeaders, obfuscatedBody);
                }
        );
    }

    private Object createResponseObfuscationHandler() {
        Method setter = findBugfenderMethod("setNetworkLoggingResponseObfuscationHandler", 1);
        if (setter == null) {
            return null;
        }
        Class<?> handlerType = setter.getParameterTypes()[0];
        return Proxy.newProxyInstance(
                handlerType.getClassLoader(),
                new Class<?>[]{handlerType},
                (proxy, method, methodArgs) -> {
                    if (method.getDeclaringClass() == Object.class) {
                        return invokeObjectMethod(proxy, method, methodArgs);
                    }
                    if (methodArgs == null || methodArgs.length < 2) {
                        return null;
                    }
                    @SuppressWarnings("unchecked")
                    Map<String, String> headers = methodArgs[0] instanceof Map
                            ? (Map<String, String>) methodArgs[0]
                            : new HashMap<>();
                    String body = methodArgs[1] instanceof String ? (String) methodArgs[1] : null;

                    Map<String, Object> args = new HashMap<>();
                    args.put("headers", headers != null ? new HashMap<>(headers) : new HashMap<String, String>());
                    args.put("body", body);

                    android.util.Log.i("BF/FlutterNet", "response obfuscation invoked");
                    Map<String, Object> response = invokeDartObfuscation("obfuscateNetworkResponse", args);
                    Map<String, String> obfuscatedHeaders = headers;
                    String obfuscatedBody = body;
                    if (response != null) {
                        obfuscatedHeaders = toStringMap(response.get("headers"));
                        obfuscatedBody = response.get("body") instanceof String ? (String) response.get("body") : null;
                    }
                    return newNetworkData(method.getReturnType(), null, obfuscatedHeaders, obfuscatedBody);
                }
        );
    }

    private static Object newNetworkData(
            Class<?> type,
            String url,
            Map<String, String> headers,
            String body
    ) throws Exception {
        for (Constructor<?> constructor : type.getConstructors()) {
            Class<?>[] params = constructor.getParameterTypes();
            if (
                    params.length == 3 &&
                            params[0] == String.class &&
                            Map.class.isAssignableFrom(params[1]) &&
                            params[2] == String.class
            ) {
                return constructor.newInstance(url, headers, body);
            }
            if (
                    params.length == 2 &&
                            Map.class.isAssignableFrom(params[0]) &&
                            params[1] == String.class
            ) {
                return constructor.newInstance(headers, body);
            }
        }
        return null;
    }

    private static Object invokeObjectMethod(Object proxy, Method method, Object[] args) {
        String name = method.getName();
        if ("toString".equals(name)) {
            return "BugfenderNetworkObfuscationHandlerProxy";
        }
        if ("hashCode".equals(name)) {
            return System.identityHashCode(proxy);
        }
        if ("equals".equals(name)) {
            return proxy == (args != null && args.length > 0 ? args[0] : null);
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> invokeDartObfuscation(String method, Map<String, Object> args) {
        if (channel == null) {
            return null;
        }

        // Avoid deadlocking the UI thread while waiting for Dart.
        if (android.os.Looper.myLooper() == android.os.Looper.getMainLooper()) {
            return null;
        }

        final CountDownLatch latch = new CountDownLatch(1);
        final AtomicReference<Map<String, Object>> resultRef = new AtomicReference<>();

        // MethodChannel callbacks must run on the platform thread.
        new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
            channel.invokeMethod(method, args, new MethodChannel.Result() {
                @Override
                public void success(Object result) {
                    if (result instanceof Map) {
                        resultRef.set((Map<String, Object>) result);
                    }
                    latch.countDown();
                }

                @Override
                public void error(String errorCode, String errorMessage, Object errorDetails) {
                    latch.countDown();
                }

                @Override
                public void notImplemented() {
                    latch.countDown();
                }
            });
        });

        try {
            if (!latch.await(3, TimeUnit.SECONDS)) {
                return null;
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return null;
        }
        return resultRef.get();
    }

    private Map<String, String> toStringMap(Object value) {
        Map<String, String> result = new HashMap<>();
        if (!(value instanceof Map)) {
            return result;
        }
        Map<?, ?> raw = (Map<?, ?>) value;
        for (Map.Entry<?, ?> entry : raw.entrySet()) {
            if (entry.getKey() != null) {
                result.put(String.valueOf(entry.getKey()),
                        entry.getValue() != null ? String.valueOf(entry.getValue()) : "");
            }
        }
        return result;
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
