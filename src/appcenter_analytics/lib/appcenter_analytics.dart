import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

class AppCenterAnalytics {
  static String get id => (defaultTargetPlatform == TargetPlatform.iOS)
      ? "MSAnalytics"
      : "com.microsoft.appcenter.analytics.Analytics";

  static const MethodChannel _channel = const MethodChannel(
      'aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_analytics');

  static Future<bool> get isEnabled =>
      _channel.invokeMethod('isEnabled').then((r) => r as bool);

  static Future setEnabled(bool isEnabled) =>
      _channel.invokeMethod('setEnabled', <String, bool>{
        'isEnabled': isEnabled,
      });

  static Future trackEvent(String name, [Map<String, String> properties]) =>
      _channel.invokeMethod('trackEvent', <String, dynamic>{
        'name': name,
        'properties': properties ?? <String, String>{},
      });
}
