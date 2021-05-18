## [2.0.0]
* releasing to stable now that Dart SDK version to 2.12 is stable
* null safety
* add support for web (loading js file from our cdn)

## [2.0.0-web.1]
* add support for web

## [2.0.0-nullsafety.0]
* bump minimum Dart SDK version to 2.12 prerelease
* make appropriate method arguments non-nullable

## [1.2.2] - Add wrapper functions
* add support for configuration options upon initialization (API endpoints, log to console, max storage size, automatic logging, device name)
* add support for setForceEnabled, forceSendOnce, getDeviceUri, getSessionUri, set key-values other than string, send manual crashes, send user feedback
* rename internal Android classes to com.bugfender package

## [1.2.1-rc1] - Updated libraries

* **hits a CocoaPods bug** that is only solved in master ([see how to use CocoaPods in master](https://guides.cocoapods.org/using/a-gemfile.html))
* updated the underlying libraries to iOS SDK ~>1.9
* as a result, the deployment target version in iOS is now 10 (add `platform :ios, '10.0'` to your Podfile and `MinimumOSVersion`=`10.0` in your `AppFrameworkInfo.plist`)

## [1.2.0] - Updated Android library

* updated the underlying library to Android SDK 3.+

## [1.1.0] - New log levels

* added new log levels, the "tag" is now always sent empty
* updated example app
* updated installation instructions in readme to point to pub.dev
* removed unused dependency with Android support library

## [1.0.0] - Swift support - breaking change

* replaced iOS SDK with Swift supported pod
* replaced example with iOS Swift project

## [0.0.5] - minor fixes

* added environment variable in pubspec.yaml (to be compatible with latest the flutter version)
* added ObjC dependency in podspec (in order for the iOS side to work)
* removed manual BugfenderSDK pod version number override (to pull the latest automatically, currently 1.6.3 instead 1.5.2)
