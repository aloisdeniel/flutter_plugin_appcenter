#import "AppcenterCrashesPlugin.h"

#import <AppCenterCrashes/AppCenterCrashes.h>

@implementation AppcenterCrashesPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_crashes"
            binaryMessenger:[registrar messenger]];
  AppcenterCrashesPlugin* instance = [[AppcenterCrashesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
   if([@"isEnabled" isEqualToString:call.method])
   {
       result([NSNumber numberWithBool:[MSCrashes isEnabled]]);
   }
   else if([@"setEnabled" isEqualToString:call.method])
   {
        // Arguments
        NSNumber *isEnabled = call.arguments[@"isEnabled"];

        // Invoking plugin method
        [MSCrashes setEnabled:isEnabled.boolValue];
        result(nil);
   }
   else if([@"generateTestCrash" isEqualToString:call.method])
   {
        [MSCrashes generateTestCrash];
        result(nil);
   }
   else
   {
        result(FlutterMethodNotImplemented);
   }
}

@end
