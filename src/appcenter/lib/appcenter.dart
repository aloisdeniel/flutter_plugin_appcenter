import 'dart:async';

import 'package:flutter/services.dart';

class AppCenter {

  static const MethodChannel _channel = const MethodChannel('aloisdeniel.github.com/flutter_plugin_appcenter/appcenter');

  /// Starts App Center services
  static Future<String> configure(String app_secret) =>  _channel.invokeMethod('configure', <String, dynamic>{
    'app_secret': app_secret,
  });

  static Future<String> start(String app_secret, List<String> services) =>  _channel.invokeMethod('start', <String, dynamic>{
    'app_secret': app_secret,
    'services': services
  });

  static Future<String> get installId =>  _channel.invokeMethod('installId');

  static Future<bool> get isEnabled =>  _channel.invokeMethod('isEnabled');

  static Future setEnabled(bool isEnabled) =>  _channel.invokeMethod('setEnabled', <String, bool>{
    'isEnabled': isEnabled,
  });
}

