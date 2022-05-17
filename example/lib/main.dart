import 'package:flutter/material.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';

void main() {
  runApp(new MyApp());
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
      await FlutterBugfender.init("EjOeAkNNgeGeP5k8sgGR0ppwSYOtUKie",
          printToConsole: true,
          enableCrashReporting: true,
          enableAndroidLogcatLogging: false,
          overrideDeviceName: "Anonymous",
          version: "1.0",
          build: "555");
      await FlutterBugfender.log("Working fine!");
      await FlutterBugfender.fatal("Fatal sent!");
      await FlutterBugfender.error("Error sent!");
      await FlutterBugfender.warn("Warning sent!");
      await FlutterBugfender.info("Info sent!");
      await FlutterBugfender.debug("Debug sent!");
      await FlutterBugfender.trace("Trace sent!");
      await FlutterBugfender.sendLog(
          line: 42,
          method: "fakeMethod()",
          file:"fakeFile.fake",
          level: LogLevel.info,
          tag: "TAG",
          text: "Custom log 1"
      );

      await FlutterBugfender.sendLog(
          tag: "TAG",
          text: "Custom log 2"
      );
      await FlutterBugfender.setDeviceString(
          "user.email", "example@example.com");
      await FlutterBugfender.setDeviceInt("user.id", 1);
      await FlutterBugfender.setDeviceFloat("user.weight", 1.234);
      await FlutterBugfender.setDeviceBool("user.team", true);
      await FlutterBugfender.removeDeviceKey("user.team");
      print(await FlutterBugfender.sendCrash("Test Crash", "Stacktrace here!"));
      print(await FlutterBugfender.sendIssue(
          "Test Issue", "Issue value goes here!"));
      print(await FlutterBugfender.sendUserFeedback(
          "Test user feedback", "User feedback details here!"));
      await FlutterBugfender.setForceEnabled(true);
      await FlutterBugfender.setForceEnabled(false);
      await FlutterBugfender.forceSendOnce();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
