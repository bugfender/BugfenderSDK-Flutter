import 'package:flutter/material.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';

void main() {
  FlutterBugfender.handleUncaughtErrors(() async {
    await FlutterBugfender.init("<INSERT YOUR BUGFENDER APP KEY>",
        printToConsole: true,
        enableCrashReporting: true,
        enableAndroidLogcatLogging: false,
        version: "1.0",
        build: "555");
    FlutterBugfender.log("hello world!");
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = 'Bugfender not started';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    try {
      FlutterBugfender.log("Working fine!");
      FlutterBugfender.fatal("Fatal sent!");
      FlutterBugfender.error("Error sent!");
      FlutterBugfender.warn("Warning sent!");
      FlutterBugfender.info("Info sent!");
      FlutterBugfender.debug("Debug sent!");
      FlutterBugfender.trace("Trace sent!");
      FlutterBugfender.sendLog(
          line: 42,
          method: "fakeMethod()",
          file: "fakeFile.fake",
          level: LogLevel.info,
          tag: "TAG",
          text: "Custom log 1");

      FlutterBugfender.sendLog(tag: "TAG", text: "Custom log 2");
      FlutterBugfender.setDeviceString("user.email", "example@example.com");
      FlutterBugfender.setDeviceInt("user.id", 1);
      FlutterBugfender.setDeviceFloat("user.weight", 1.234);
      FlutterBugfender.setDeviceBool("user.team", true);
      FlutterBugfender.removeDeviceKey("user.team");
      print(await FlutterBugfender.sendCrash("Test Crash", "Stacktrace here!"));
      print(await FlutterBugfender.sendIssue(
          "Test Issue", "Issue value goes here!"));
      print(await FlutterBugfender.sendUserFeedback(
          "Test user feedback", "User feedback details here!"));
      FlutterBugfender.setForceEnabled(true);
      FlutterBugfender.setForceEnabled(false);
      FlutterBugfender.forceSendOnce();
      print(await FlutterBugfender.getDeviceUri());
      print(await FlutterBugfender.getSessionUri());
    } catch (e) {
      print("Error found!!!! $e");
      throw e;
    }

    if (!mounted) return;

    setState(() {
      _message = "All working fine!";
    });
  }

  getUserFeedback() async {
    print(await FlutterBugfender.getUserFeedback());
  }

  generateException() async {
    var result = 100 ~/ 0;
  }

  generateError() {
    throw Error();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Bugfender Plugin example app'),
        ),
        body: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text('$_message\n'),
              new ElevatedButton(
                onPressed: () {
                  getUserFeedback();
                },
                child: Text('Show Feedback Screen'),
              ),
              new ElevatedButton(
                onPressed: () {
                  generateException();
                },
                child: Text('Generate exception'),
              ),
              new ElevatedButton(
                onPressed: () {
                  generateError();
                },
                child: Text('Generate error'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
