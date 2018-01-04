import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _app_secret;
  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false, _areCrashesEnabled = false;

  _MyAppState() {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    _app_secret = ios ? "a8a33033-ef2f-4911-a664-a7d118287ce7" : "3f1f3b0e-24ff-436a-b42d-3c08b117d46a";
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await AppCenter.start(_app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

    if (!mounted)
      return;

    var installId = await AppCenter.installId;

    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Text('Install identifier: $_installId'),
              new Text('Analytics: $_areAnalyticsEnabled'),
              new Text('Crashes: $_areCrashesEnabled'),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Text('Send events'),
                  new IconButton(
                    icon: new Icon(Icons.map),
                    tooltip: 'map',
                    onPressed: () { AppcenterAnalytics.trackEvent("map"); },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.casino),
                    tooltip: 'casino',
                    onPressed: () { AppcenterAnalytics.trackEvent("casino", { "dollars" : "10" }); },
                  ),
                ])
            ]
        ),
      ),
    );
  }
}
