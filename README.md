# flutter_bugfender

A Bugfender Wrapper plugin (implementing native code) for Flutter Projects.

**Note:** This plugin was provided by the community, hence it is published "AS IS", our support might not always be able to help you.

## Using the package

Edit `pubspec.yaml` and add add `flutter_bugfender` to `dev_dependencies`:

```
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_bugfender: ^1.0.0
```

Then run `flutter pub get` (or ‘Packages Get’ in IntelliJ) to download the package.

Edit `lib/main.dart` and add an import:

```
import 'package:flutter_bugfender/flutter_bugfender.dart';
```

And in your main application builder:

```
FlutterBugfender.init("YOUR_APP_KEY");
```

You can also call:

 * FlutterBugfender.log("Working fine!");
 * FlutterBugfender.fatal("Fatal sent!");
 * FlutterBugfender.error("Error sent!");
 * FlutterBugfender.warn("Warning sent!");
 * FlutterBugfender.info("Info sent!");
 * FlutterBugfender.debug("Debug sent!");
 * FlutterBugfender.trace("Trace sent!");
 * FlutterBugfender.setDeviceString("user.email", "example@example.com");
 * FlutterBugfender.removeDeviceString("user.email");
 * FlutterBugfender.sendIssue("Test Issue", "Issue description goes here!");
