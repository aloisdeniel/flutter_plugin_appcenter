#import "AppcenterAuthPlugin.h"
@import AppCenter;
@import AppCenterAuth;

@implementation AppcenterAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"uk.co.tomalabaster/flutter_plugin_appcenter/appcenter_crashes"
            binaryMessenger:[registrar messenger]];
  AppcenterAuthPlugin* instance = [[AppcenterAuthPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"signIn" isEqualToString:call.method]) {
    [self signIn:call result:result];
  } else if ([@"signOut" isEqualToString:call.method]) {
    [self signOut:call result:result];
  } else if ([@"isEnabled" isEqualToString:call.method]) {
    [self isEnabled:call result:result];
  } else if ([@"setEnabled" isEqualToString:call.method]) {
    [self setEnabled:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)signIn:(FlutterMethodCall*)call result:(FlutterResult)result {
  [MSAuth signInWithCompletionHandler:^(MSUserInformation *_Nullable userInformation, NSError *_Nullable error) {
    if (error) {
      result([FlutterError errorWithCode:@"Auth error" message:error.localizedDescription details:nil]);
    } else {
      NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        
      userInfo[@"idToken"] = userInformation.idToken;
      userInfo[@"accessToken"] = userInformation.accessToken;
      userInfo[@"accountId"] = userInformation.accountId;
      userInfo[@"claims"] = [self getClaimsFromIdToken:userInformation.idToken];
        
      result(userInfo);
    }
  }];
}

- (NSDictionary*)getClaimsFromIdToken:(NSString*)idToken {
    NSArray *tokenSplit = [idToken componentsSeparatedByString:@"."];
    if ([tokenSplit count] > 1) {
        NSString *rawClaims = tokenSplit[1];
        size_t paddedLength = rawClaims.length + (4 - rawClaims.length % 4) % 4;
        rawClaims = [rawClaims stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
        NSData *claimsData = [[NSData alloc] initWithBase64EncodedString:rawClaims options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (claimsData) {
            NSError *error;
            NSDictionary *claims = [NSJSONSerialization JSONObjectWithData:claimsData options:0 error:&error];
            if (!error) {
                return claims;
            } else {
                return [[NSDictionary alloc] init];
            }
        } else {
            return [[NSDictionary alloc] init];
        }
    } else {
        return [[NSDictionary alloc] init];
    }
}

- (void)signOut:(FlutterMethodCall*)call result:(FlutterResult)result {
  [MSAuth signOut];
  result(nil);
}

- (void)isEnabled:(FlutterMethodCall*)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[MSAuth isEnabled]]);
}

- (void)setEnabled:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSNumber *isEnabled = call.arguments[@"isEnabled"];

  [MSAuth setEnabled:isEnabled.boolValue];
  result(nil);
}

@end
