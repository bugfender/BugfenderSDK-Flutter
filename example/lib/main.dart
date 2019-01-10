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
      await FlutterBugfender.init("534EKHhDlA0cJuVyPKQNCtIVqMepG6P1");
      await FlutterBugfender.log("Working fine!");
      await FlutterBugfender.warn("Warning sent!");
      await FlutterBugfender.error("Error sent!");
      await FlutterBugfender.setDeviceString("user.email", "example@example.com");
      await FlutterBugfender.setDeviceString("user.id", "1");
      await FlutterBugfender.setDeviceString("user.team", "EasyFlatBCN");
      await FlutterBugfender.removeDeviceString("user.team");
      await FlutterBugfender.sendIssue("Test Issue", "Issue value goes here!");
    } catch (e) {
      print("Error found!!!! $e");
      throw e;
    }

    if (!mounted) return;

    setState(() {
      _message = "All working fine!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Bugfender Plugin example app'),
        ),
        body: new Center(
          child: new Text('$_message\n'),
        ),
      ),
    );
  }
}
