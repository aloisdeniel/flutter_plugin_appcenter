#import <Flutter/Flutter.h>

@interface AppcenterAuthPlugin : NSObject<FlutterPlugin>
- (void)signIn:(FlutterMethodCall*)call result:(FlutterResult)result;
- (void)signOut:(FlutterMethodCall*)call result:(FlutterResult)result;
- (void)isEnabled:(FlutterMethodCall*)call result:(FlutterResult)result;
- (void)setEnabled:(FlutterMethodCall*)call result:(FlutterResult)result;
@end
