import 'dart:async';

import 'package:flutter/services.dart';

class AppCenter {

  static const MethodChannel _channel = const MethodChannel('aloisdeniel.github.com/flutter_plugin_appcenter/appcenter');

  /// Starts App Center services
  static Future<String> configure(String appSecret) =>  _channel.invokeMethod('configure', <String, String>{
    'app_secret': appSecret,
  });

  static Future<dynamic> start(String appSecret, List<String> services) =>  _channel.invokeMethod('start', <String, dynamic>{
    'app_secret': appSecret,
    'services': services
  });

  static Future<dynamic> get installId =>  _channel.invokeMethod('installId');

  static Future<bool> get isEnabled =>  _channel.invokeMethod('isEnabled');

  static Future setEnabled(bool isEnabled) =>  _channel.invokeMethod('setEnabled', <String, bool>{
    'isEnabled': isEnabled,
  });
}

