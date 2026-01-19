# flutter_bugfender_example

Demonstrates how to use the flutter_bugfender plugin with Bugfender SDK on iOS, Android, and Web.

## Getting Started

### Prerequisites

1. Flutter SDK installed (see [Flutter documentation](https://flutter.io/))
2. A Bugfender app key (get one at [bugfender.com](https://bugfender.com))

### Setup

1. **Get dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure your Bugfender app key:**
   
   Open `lib/main.dart` and replace `"<INSERT YOUR BUGFENDER APP KEY>"` with your actual Bugfender app key:
   ```dart
   await FlutterBugfender.init("<INSERT YOUR BUGFENDER APP KEY>",
       printToConsole: true,
       enableCrashReporting: true,
       ...
   ```

### Running the Example App

#### Web

**Option 1: Run in Chrome (recommended for development)**
```bash
flutter run -d chrome
```

**Option 2: Run with web server**
```bash
flutter run -d web-server
```
This will start a local web server (usually on `http://localhost:8080`).

**Note:** If web support is not enabled, run:
```bash
flutter config --enable-web
```

#### iOS

```bash
flutter run -d ios
```

**Note:** Requires Xcode and iOS Simulator or a physical iOS device.

#### Android

```bash
flutter run -d android
```

**Note:** Requires Android Studio, Android SDK, and an emulator or physical Android device.

### What the Example Demonstrates

The example app demonstrates various Bugfender features:

- **Logging:** Different log levels (fatal, error, warn, info, debug, trace)
- **Device Information:** Setting device keys (string, int, float, bool)
- **Issues & Crashes:** Sending crashes, issues, and user feedback
- **URLs:** Getting device and session URLs
- **User Feedback:** Showing the feedback screen
- **Error Handling:** Demonstrating exception and error reporting

### Troubleshooting

- **Web:** Ensure the `bugfender.js` asset is properly loaded. The plugin automatically loads it at runtime.
- **iOS:** Make sure CocoaPods dependencies are installed: `cd ios && pod install`
- **Android:** Ensure the Android SDK and build tools are properly configured.
