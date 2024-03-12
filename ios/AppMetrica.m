/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <React/RCTConvert.h>
#import "AppMetrica.h"
#import <Firebase/Firebase.h>
#import "AppMetricaUtils.h"
#import <YandexMobileMetricaPush/YMPYandexMetricaPush.h>


static NSString *const kYMMReactNativeExceptionName = @"ReactNativeException";

@implementation AppMetrica

@synthesize methodQueue = _methodQueue;

RCT_EXPORT_MODULE();


- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}


+ (NSDictionary *)addCustomPropsToUserProps:(NSDictionary *_Nullable)userProps withLaunchOptions:(NSDictionary *_Nullable)launchOptions  {
    NSMutableDictionary *appProperties = userProps != nil ? [userProps mutableCopy] : [NSMutableDictionary dictionary];
    appProperties[@"isHeadless"] = @([RCTConvert BOOL:@(NO)]);
        
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
      if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        appProperties[@"isHeadless"] = @([RCTConvert BOOL:@(YES)]);
      }
    }
    
    return [NSDictionary dictionaryWithDictionary:appProperties];
}


RCT_EXPORT_METHOD(activate:(NSDictionary *)configDict)
{
    [YMMYandexMetrica activateWithConfiguration:[AppMetricaUtils configurationForDictionary:configDict]];
}

RCT_EXPORT_METHOD(reportUserProfile:(NSDictionary *)configDict)
{
    [YMMYandexMetrica reportUserProfile:[AppMetricaUtils configurationForUserProfile:configDict] onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



RCT_EXPORT_METHOD(initPush:(NSData *)deviceToken)
{

    #ifdef DEBUG
       YMPYandexMetricaPushEnvironment pushEnvironment = YMPYandexMetricaPushEnvironmentDevelopment;
    #else
       YMPYandexMetricaPushEnvironment pushEnvironment = YMPYandexMetricaPushEnvironmentProduction;
    #endif
   [YMPYandexMetricaPush setDeviceTokenFromData:[FIRMessaging messaging].APNSToken pushEnvironment:pushEnvironment];
    
}

RCT_EXPORT_METHOD(getLibraryApiLevel)
{
    // It does nothing for iOS
}

RCT_EXPORT_METHOD(getLibraryVersion:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([YMMYandexMetrica libraryVersion]);
}

RCT_EXPORT_METHOD(pauseSession)
{
    [YMMYandexMetrica pauseSession];
}

RCT_EXPORT_METHOD(reportAppOpen:(NSString *)deeplink)
{
    [YMMYandexMetrica handleOpenURL:[NSURL URLWithString:deeplink]];
}




RCT_EXPORT_METHOD(reportError:(NSString *)message) {
    NSException *exception = [[NSException alloc] initWithName:message reason:nil userInfo:nil];
    [YMMYandexMetrica reportError:message exception:exception onFailure:NULL];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)eventName:(NSDictionary *)attributes)
{
    if (attributes == nil) {
        [YMMYandexMetrica reportEvent:eventName onFailure:^(NSError *error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }];
    } else {
        [YMMYandexMetrica reportEvent:eventName parameters:attributes onFailure:^(NSError *error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }];
    }
}

RCT_EXPORT_METHOD(reportReferralUrl:(NSString *)referralUrl)
{
    [YMMYandexMetrica reportReferralUrl:[NSURL URLWithString:referralUrl]];
}

RCT_EXPORT_METHOD(requestAppMetricaDeviceID:(RCTResponseSenderBlock)listener)
{
    YMMAppMetricaDeviceIDRetrievingBlock completionBlock = ^(NSString *_Nullable appMetricaDeviceID, NSError *_Nullable error) {
        listener(@[[self wrap:appMetricaDeviceID], [self wrap:[AppMetricaUtils stringFromRequestDeviceIDError:error]]]);
    };
    [YMMYandexMetrica requestAppMetricaDeviceIDWithCompletionQueue:nil completionBlock:completionBlock];
}

RCT_EXPORT_METHOD(resumeSession)
{
    [YMMYandexMetrica resumeSession];
}

RCT_EXPORT_METHOD(sendEventsBuffer)
{
    [YMMYandexMetrica sendEventsBuffer];
}

RCT_EXPORT_METHOD(setLocation:(NSDictionary *)locationDict)
{
    [YMMYandexMetrica setLocation:[AppMetricaUtils locationForDictionary:locationDict]];
}

RCT_EXPORT_METHOD(setLocationTracking:(BOOL)enabled)
{
    [YMMYandexMetrica setLocationTracking:enabled];
}

RCT_EXPORT_METHOD(setStatisticsSending:(BOOL)enabled)
{
    [YMMYandexMetrica setStatisticsSending:enabled];
}

RCT_EXPORT_METHOD(setUserProfileID:(NSString *)userProfileID)
{
    [YMMYandexMetrica setUserProfileID:userProfileID];
}

- (NSObject *)wrap:(NSObject *)value
{
    if (value == nil) {
        return [NSNull null];
    }
    return value;
}

@end
