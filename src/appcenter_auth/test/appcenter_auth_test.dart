import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appcenter_auth/appcenter_auth.dart';

void main() {
  const MethodChannel channel = MethodChannel('appcenter_auth');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AppcenterAuth.platformVersion, '42');
  });
}
