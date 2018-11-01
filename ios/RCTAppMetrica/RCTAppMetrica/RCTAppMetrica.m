#import "RCTAppMetrica.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation RCTAppMetrica {

}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(activateWithApiKey:(NSString *)apiKey)
{
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:apiKey];
    [YMMYandexMetrica activateWithConfiguration:configuration];
}

RCT_EXPORT_METHOD(activateWithConfig:(NSDictionary *)config) {
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:config[@"apiKey"]];
    if (config[@"sessionTimeout"] != [NSNull null]) {
        [configuration setSessionTimeout:[config[@"sessionTimeout"] intValue]];
    }
    if (config[@"firstActivationAsUpdate"] != [NSNull null]) {
        [configuration setHandleFirstActivationAsUpdate:[config[@"firstActivationAsUpdate"] boolValue]];
    }
    [YMMYandexMetrica activateWithConfiguration:configuration];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)message)
{
    [YMMYandexMetrica reportEvent:message onFailure:NULL];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)message parameters:(nullable NSDictionary *)params)
{
    [YMMYandexMetrica reportEvent:message parameters:params onFailure:NULL];
}

RCT_EXPORT_METHOD(reportError:(NSString *)message) {
    NSException *exception = [[NSException alloc] initWithName:message reason:nil userInfo:nil];
    [YMMYandexMetrica reportError:message exception:exception onFailure:NULL];
}

RCT_EXPORT_METHOD(setUserProfileID:(NSString *)userProfileID) {
    [YMMYandexMetrica setUserProfileID:userProfileID];
}

RCT_EXPORT_METHOD(reportUserProfile:(NSDictionary *)attributes) {
    YMMMutableUserProfile *profile = [[YMMMutableUserProfile alloc] init];
    NSMutableArray *attrsArray = [NSMutableArray array];
    for (NSString* key in attributes) {
        // predefined attributes
        if ([key isEqual: @"name"]) {
            if (attributes[key] == [NSNull null]) {
                [attrsArray addObject:[[YMMProfileAttribute name] withValueReset]];
            } else {
                [attrsArray addObject:[[YMMProfileAttribute name] withValue:[attributes[key] stringValue]]];
            }
        } else if ([key isEqual: @"gender"]) {
            if (attributes[key] == [NSNull null]) {
                [attrsArray addObject:[[YMMProfileAttribute gender] withValueReset]];
            } else {
                [attrsArray addObject:[[YMMProfileAttribute gender] withValue:[[attributes[key] stringValue] isEqual: @"female"] ? YMMGenderTypeFemale : [[attributes[key] stringValue] isEqual: @"male"] ? YMMGenderTypeMale : YMMGenderTypeOther]];
            }
        } else if ([key isEqual: @"age"]) {
            if (attributes[key] == [NSNull null]) {
                [attrsArray addObject:[[YMMProfileAttribute birthDate] withValueReset]];
            } else {
                [attrsArray addObject:[[YMMProfileAttribute birthDate] withAge:[attributes[key] intValue]]];
            }
        } else if ([key isEqual: @"birthDate"]) {
            if (attributes[key] == [NSNull null]) {
                [attrsArray addObject:[[YMMProfileAttribute birthDate] withValueReset]];
            } else if ([attributes[key] isKindOfClass:[NSArray class]]) {
                NSArray *date = [attributes[key] array];
                if ([date count] == 1) {
                    [attrsArray addObject:[[YMMProfileAttribute birthDate] withYear:[[date objectAtIndex:0] intValue]]];
                } else if ([[attributes[key] array] count] == 2) {
                    [attrsArray addObject:[[YMMProfileAttribute birthDate] withYear:[[date objectAtIndex:0] intValue] month:[[date objectAtIndex:1] intValue]]];
                } else if ([[attributes[key] array] count] == 3) {
                    [attrsArray addObject:[[YMMProfileAttribute birthDate] withYear:[[date objectAtIndex:0] intValue] month:[[date objectAtIndex:1] intValue] day:[[date objectAtIndex:2] intValue]]];
                }
            } else {
                // number of milliseconds since Unix epoch
                NSDate *date = [attributes[key] date];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *dateComponents =
                    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
                [attrsArray addObject:[[YMMProfileAttribute birthDate] withDateComponents:dateComponents]];
            }
        } else if ([key isEqual: @"notificationsEnabled"]) {
            if (attributes[key] == [NSNull null]) {
                [attrsArray addObject:[[YMMProfileAttribute notificationsEnabled] withValueReset]];
            } else {
                [attrsArray addObject:[[YMMProfileAttribute notificationsEnabled] withValue:[attributes[key] boolValue]]];
            }
        // custom attributes
        } else {
            // TODO: come up with a syntax solution to reset custom attributes. `null` will break type checking here
            if ([attributes[key] isEqual: @YES] || [attributes[key] isEqual: @NO]) {
                [attrsArray addObject:[[YMMProfileAttribute customBool:key] withValue:[attributes[key] boolValue]]];
            } else if ([attributes[key] isKindOfClass:[NSNumber class]]) {
                [attrsArray addObject:[[YMMProfileAttribute customNumber:key] withValue:[attributes[key] doubleValue]]];
                // [NSNumber numberWithInt:[attributes[key] intValue]]
            } else if ([attributes[key] isKindOfClass:[NSString class]]) {
                if ([attributes[key] hasPrefix:@"+"] || [attributes[key] hasPrefix:@"-"]) {
                    [attrsArray addObject:[[YMMProfileAttribute customCounter:key] withDelta:[attributes[key] doubleValue]]];
                } else {
                    [attrsArray addObject:[[YMMProfileAttribute customString:key] withValue:attributes[key]]];
                }
            }
        }
    }

    [profile applyFromArray: attrsArray];
    [YMMYandexMetrica reportUserProfile:[profile copy] onFailure:NULL];
}

@end
