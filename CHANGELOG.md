## [1.1.0] - Tags support and basic extended logging

* Added tag parameter to default `log()` method
* Added `l()` method with extended parameters like `tag`, `methodName` and `className`
* Added `forceSendOnce()` method to synchronize all logs and issues with the server once, regardless if this device is enabled or not
* Updated README.md with instruction on how to get current method and class name

## [1.0.0] - Swift support - breaking change

* replaced iOS SDK with Swift supported pod
* replaced example with iOS Swift project

## [0.0.5] - minor fixes

* added environment variable in pubspec.yaml (to be compatible with latest the flutter version)
* added ObjC dependency in podspec (in order for the iOS side to work)
* removed manual BugfenderSDK pod version number override (to pull the latest automatically, currently 1.6.3 instead 1.5.2)
