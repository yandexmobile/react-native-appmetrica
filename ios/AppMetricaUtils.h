/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <CoreLocation/CoreLocation.h>
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@interface AppMetricaUtils : NSObject

+ (YMMYandexMetricaConfiguration *)configurationForDictionary:(NSDictionary *)configDict;
+ (CLLocation *)locationForDictionary:(NSDictionary *)locationDict;
+ (NSString *)stringFromRequestDeviceIDError:(NSError *)error;

@end
