# flutter_bugfender

A Bugfender Wrapper plugin (implementing native code) for Flutter Projects.

**Note:** This plugin was provided by the community, hence it is published "AS IS", our support might not always be able to help you.

## Using the package

Edit `pubspec.yaml` and add add `flutter_bugfender` to `dependencies`:

```
dependencies:
  flutter_bugfender: ^1.1.0
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
 * FlutterBugfender.log("Working fine!", tag: "Tag");
 * FlutterBugfender.warn("Warning sent!");
 * FlutterBugfender.error("Error sent!");
 * FlutterBugfender.setDeviceString("user.email", "example@example.com");
 * FlutterBugfender.removeDeviceString("user.email");
 * FlutterBugfender.sendIssue("Test Issue", "Issue description goes here!");
 * FlutterBugfender.forceSendOnce();
 * FlutterBugfender.l("Working fine!", tag: 'Info', methodName: "some method", className: "some class")

 ## Getting real method and class name

 You can use [`stack_trace`](https://pub.dev/packages/stack_trace) package or any other tool to get current execution context. Then you can pass it to `l()` method.

 In case of `stack_trace` you can find calling method and class name by:

 ```dart
import 'package:stack_trace/stack_trace.dart';

final className = Trace.current().frames[1].member.split(".")[0];
final methodName = Trace.current().frames[1].member.split(".")[1];
FlutterBugfender.l(message, tag: 'Info', methodName: methodName, className: className);
```
