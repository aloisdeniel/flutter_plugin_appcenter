import 'dart:async';

import 'package:flutter/services.dart';

class Appcenter {
  static const MethodChannel _channel =
      const MethodChannel('appcenter');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
