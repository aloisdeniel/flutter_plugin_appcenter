import 'dart:async';

import 'package:appcenter_auth/models/user_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppCenterAuth {
  static String get id => (defaultTargetPlatform == TargetPlatform.iOS)
      ? "MSAuth"
      : "com.microsoft.appcenter.auth.Auth";
      
  static const MethodChannel _channel =
      const MethodChannel('uk.co.tomalabaster/flutter_plugin_appcenter/appcenter_auth');

  static Future<UserInformation> signIn() async {
    var result = await _channel.invokeMethod('signIn');

    return UserInformation.fromMap(Map<String, dynamic>.from(result));
  }

  static Future signOut() =>
      _channel.invokeMethod('signOut');

  static Future<bool> get isEnabled =>
      _channel.invokeMethod('isEnabled').then((r) => r as bool);

  static Future setEnabled(bool isEnabled) =>
      _channel.invokeMethod('setEnabled', <String, bool>{
        'isEnabled': isEnabled,
      });
}
