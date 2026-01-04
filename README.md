# flutter_bugfender

A Bugfender Wrapper plugin (implementing native code) for Flutter Projects.

**Note:** This plugin was provided by the community, hence it is published "AS IS", our support might not always be able to help you.

## Using the package

Edit `pubspec.yaml` and add add `flutter_bugfender` to `dependencies`:

```
dependencies:
  flutter:
    sdk: flutter
  flutter_bugfender: ^4.0.0
```

Then run `flutter pub get` (or ‘Packages Get’ in IntelliJ) to download the package.

Edit `lib/main.dart` and add an import:

```dart
import 'package:flutter_bugfender/flutter_bugfender.dart';
```

And wrap your `runApp` statement like this:

```dart
void main() {
  FlutterBugfender.handleUncaughtErrors(() async {
    await FlutterBugfender.init("YOUR_APP_KEY",
        enableCrashReporting: true, // these are optional, but recommended
        enableUIEventLogging: true,
        enableAndroidLogcatLogging: true);
    FlutterBugfender.log("hello world!");
    runApp(new MyApp());
  });
}
```

# Documentation
For information on how to use our SDK, you can check the [documentation](https://docs.bugfender.com/docs/platforms/hybrid-platforms/bugfender-for-flutter) to configure your project.
