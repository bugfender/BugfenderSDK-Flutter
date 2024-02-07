# flutter_bugfender

A Bugfender Wrapper plugin (implementing native code) for Flutter Projects.

**Note:** This plugin was provided by the community, hence it is published "AS IS", our support might not always be able to help you.

## Using the package

Edit `pubspec.yaml` and add add `flutter_bugfender` to `dev_dependencies`:

```
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_bugfender: ^2.1.2
```

Then run `flutter pub get` (or ‘Packages Get’ in IntelliJ) to download the package.

Edit `lib/main.dart` and add an import:

```
import 'package:flutter_bugfender/flutter_bugfender.dart';
```

And in your main application builder:

```
await FlutterBugfender.init("YOUR_APP_KEY");
```

There are other init options:
* apiUri and baseUri: alternative URLs for on-premises installations
* maximumLocalStorageSize: maximum size the local log cache will use, in bytes
* printToConsole: whether to print to console or not
* enableUIEventLogging: enable automatic logging of user interactions for native elements.
* enableCrashReporting: enable automatic crash reporting for native crashes. To report Dart exceptions see [this](#report-dart-and-flutter-exceptions).
* enableAndroidLogcatLogging: enable automatic logging of logcat (Android only)
* overrideDeviceName: specify a name for the device
* version: app version identifier (Web specific)
* build: app build identifier (Web specific)

You can also call:
```dart
FlutterBugfender.log("Working fine!");
FlutterBugfender.fatal("Fatal sent!");
FlutterBugfender.error("Error sent!");
FlutterBugfender.warn("Warning sent!");
FlutterBugfender.info("Info sent!");
FlutterBugfender.debug("Debug sent!");
FlutterBugfender.trace("Trace sent!");
FlutterBugfender.sendLog(
 line: 42,
 method: "someMethod()",
 file:"someFile",
 level: LogLevel.info,
 tag: "Custom tag",
 text: "This is a custom log"
);
FlutterBugfender.setDeviceString("user.email", "example@example.com");
FlutterBugfender.setDeviceInt("user.id", 32);
Flu tterBugfender.setDeviceFloat("user.pi", 3.14);
FlutterBugfender.setDeviceBool("user.enabled", true);
FlutterBugfender.removeDeviceKey("user.pi");
FlutterBugfender.sendCrash("Test Crash", "Stacktrace here!");
FlutterBugfender.sendIssue("Test Issue", "Issue value goes here!");
FlutterBugfender.sendUserFeedback("Test user feedback", "User feedback details here!");
FlutterBugfender.setForceEnabled(true);
FlutterBugfender.forceSendOnce();
FlutterBugfender.getDeviceUri());
FlutterBugfender.getSessionUri());
FlutterBugfender.getUserFeedback()); // Show a screen which asks for feedback
```

### Report Dart and Flutter Exceptions
To be able to report flutter exception you'll need to wrap `runApp(new MyApp())` on your main function like this:
````dart
FlutterBugfender.handleUncaughtErrors(() async {
  runApp(new MyApp());
});

````
Previous code is just syntactic sugar for the following code that you can use indistinctly if you need more control on error handling:
````dart
// Capture Flutter Error
FlutterError.onError = (FlutterErrorDetails details) async {
  FlutterError.presentError(details);
  await FlutterBugfender.sendCrash(details.exception.toString(), details.stack?.toString() ?? "");
};
// Capture Dart Exceptions 
runZonedGuarded(() {
  runApp(new MyApp());;
}, (Object error, StackTrace stack) async {
  await FlutterBugfender.sendCrash(error.toString(), stack.toString());
});
````

### Using this package in a web project
The plugin assumes the Bugfender JS library is already loaded. You may load it by adding the following snippet to your `index.html` file:

    <script defer src="https://js.bugfender.com/bugfender-v2.js"></script>
