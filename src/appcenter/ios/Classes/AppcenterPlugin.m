#import "AppcenterPlugin.h"

#import <AppCenter/AppCenter.h>

@implementation AppcenterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"aloisdeniel.github.com/flutter_plugin_appcenter/appcenter"
            binaryMessenger:[registrar messenger]];
  AppcenterPlugin* instance = [[AppcenterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
  if([@"installId" isEqualToString:call.method])
   {
        result([[MSAppCenter installId] UUIDString]);
   }
   else if([@"isEnabled" isEqualToString:call.method])
   {
        result([NSNumber numberWithBool:[MSAppCenter isEnabled]]);
   }
   else if([@"setEnabled" isEqualToString:call.method])
   {
        // Arguments
        NSNumber *isEnabled = call.arguments[@"isEnabled"];

        // Invoking plugin method
        [MSAppCenter setEnabled:isEnabled.boolValue];
        result(nil);

   }
   else if([@"configure" isEqualToString:call.method])
   {
        // Arguments
        NSString *secret = call.arguments[@"app_secret"];

        // Invoking plugin method
        [MSAppCenter configureWithAppSecret:secret];
        result(nil);
   }
   else if([@"start" isEqualToString:call.method])
   {
        // Arguments
        NSString *secret = call.arguments[@"app_secret"];
        NSArray *services = call.arguments[@"services"];

        // Processing arguments
        NSMutableArray *serviceClasses = [[NSMutableArray alloc]init];
        for (NSString* name in services) {
           [serviceClasses addObject: NSClassFromString(name)];
        }

        // Invoking plugin method
        [MSAppCenter start:secret withServices:serviceClasses];
        result(nil);
   }
   else
   {
        result(FlutterMethodNotImplemented);
   }
}

@end
