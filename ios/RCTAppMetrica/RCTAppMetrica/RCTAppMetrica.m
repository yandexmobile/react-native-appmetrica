#import "RCTAppMetrica.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation RCTAppMetrica {
    
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(activateWithApiKey:(NSString *)apiKey)
{
    [YMMYandexMetrica activateWithApiKey:apiKey];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)message)
{
    [YMMYandexMetrica reportEvent:message onFailure:NULL];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)message parameters:(nullable NSDictionary *)params)
{
    [YMMYandexMetrica reportEvent:message parameters:params onFailure:NULL];
}

@end
