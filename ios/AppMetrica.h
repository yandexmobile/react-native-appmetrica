/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */
#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>


@interface AppMetrica : NSObject <RCTBridgeModule>
+ (NSDictionary *)addCustomPropsToUserProps:(NSDictionary *_Nullable)userProps withLaunchOptions:(NSDictionary *_Nullable)launchOptions;

@end
