#import "AppCenterAnalyticsPlugin.h"

#import <AppCenterAnalytics/AppCenterAnalytics.h>

@implementation AppcenterAnalyticsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_analytics"
            binaryMessenger:[registrar messenger]];
  AppcenterAnalyticsPlugin* instance = [[AppcenterAnalyticsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
   if([@"isEnabled" isEqualToString:call.method])
   {
       result([NSNumber numberWithBool:[MSAnalytics isEnabled]]);
   }
   else if([@"setEnabled" isEqualToString:call.method])
   {
        // Arguments
        NSNumber *isEnabled = call.arguments[@"isEnabled"];

        // Invoking plugin method
        [MSAnalytics setEnabled:isEnabled.boolValue];
        result(nil);
   }
   else if([@"trackEvent" isEqualToString:call.method])
   {
        // Arguments
        NSString *name = call.arguments[@"name"];
        NSDictionary *properties = call.arguments[@"properties"];

        // Invoking plugin method

        if([properties count] == 0)
        {
            [MSAnalytics trackEvent:name];
        }
        else
        {
            [MSAnalytics trackEvent:name withProperties:properties];
        }
        result(nil);
   }
   else
   {
        result(FlutterMethodNotImplemented);
   }
}

@end
