import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:appcenter_auth/appcenter_auth.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appSecret;
  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false;
  bool _areCrashesEnabled = false;
  bool _isAuthEnabled = false;

  _MyAppState() {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    _appSecret = ios ? "a8a33033-ef2f-4911-a664-a7d118287ce7" : "3f1f3b0e-24ff-436a-b42d-3c08b117d46a";
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await AppCenter.start(
        _appSecret, [AppCenterAnalytics.id, AppCenterCrashes.id, AppcenterAuth.id]);

    if (!mounted) return;

    var installId = await AppCenter.installId;

    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;
    var isAuthEnabled = await AppcenterAuth.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
      _isAuthEnabled = isAuthEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appcenter plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Install identifier:\n $_installId'),
            Text('Analytics: $_areAnalyticsEnabled'),
            Text('Crashes: $_areCrashesEnabled'),
            Text('Auth: $_isAuthEnabled'),
            RaisedButton(
              child: Text('Generate test crash'),
              onPressed: AppCenterCrashes.generateTestCrash,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Send events'),
                IconButton(
                  icon: Icon(Icons.map),
                  tooltip: 'map',
                  onPressed: () {
                    AppCenterAnalytics.trackEvent("map");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.casino),
                  tooltip: 'casino',
                  onPressed: () {
                    AppCenterAnalytics.trackEvent("casino", {"dollars": "10"});
                  },
                ),
              ],
            ),
            RaisedButton(
              child: Text('Sign in'),
              onPressed: () async {
                var userInfo = await AppcenterAuth.signIn();
                print(userInfo.accessToken);
              },
            ),
            RaisedButton(
              child: Text('Sign out'),
              onPressed: () async {
                await AppcenterAuth.signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
