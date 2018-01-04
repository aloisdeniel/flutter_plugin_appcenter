import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

class AppCenterCrashes {

  static String get id => (defaultTargetPlatform == TargetPlatform.iOS) ? "MSCrashes" : "com.microsoft.appcenter.crashes.Crashes";

  static const MethodChannel _channel = const MethodChannel('aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_crashes');

  static Future<bool> get isEnabled =>  _channel.invokeMethod('isEnabled');

  static Future setEnabled(bool isEnabled) =>  _channel.invokeMethod('setEnabled', <String, bool>{
    'isEnabled': isEnabled,
  });
}
