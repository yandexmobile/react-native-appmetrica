/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "AppMetrica.h"
#import "AppMetricaUtils.h"

static NSString *const kYMMReactNativeExceptionName = @"ReactNativeException";

@implementation AppMetrica

@synthesize methodQueue = _methodQueue;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(activate:(NSDictionary *)configDict)
{
    [YMMYandexMetrica activateWithConfiguration:[AppMetricaUtils configurationForDictionary:configDict]];
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

///*
/// E-commerce
///
- (YMMECommerceScreen *)createScreen:(NSDictionary *)screen {
    YMMECommerceScreen *screenObj = [[YMMECommerceScreen alloc] initWithName:screen[@"name"]
                                                          categoryComponents:screen[@"categoryComponents"]
                                                                 searchQuery:screen[@"searchQuery"]
                                                                     payload:screen[@"payload"]];
    return screenObj;
}

- (YMMECommerceReferrer *)createReferrer:(NSDictionary *)referrer {
    if (referrer == nil) return nil;
    YMMECommerceScreen *screenObj = referrer[@"screen"] != nil ? [self createScreen:referrer[@"screen"]] : nil;
    return [[YMMECommerceReferrer alloc] initWithType:referrer[@"type"]
                                           identifier:referrer[@"identifier"]
                                               screen:screenObj];
}

- (YMMECommercePrice *)createPrice:(NSDictionary *)price {
    if (price == nil) return nil;
    NSDictionary *fiatDict = price[@"fiat"];
    NSNumber *fiatValue = fiatDict[@"value"];
    YMMECommerceAmount *fiat = [[YMMECommerceAmount alloc] initWithUnit:fiatDict[@"currency"] value:[NSDecimalNumber decimalNumberWithDecimal:fiatValue.decimalValue]];
    // TODO: internalComponents
    return [[YMMECommercePrice alloc] initWithFiat:fiat];
}

- (YMMECommerceProduct *)createProduct:(NSDictionary *)product {
    return [[YMMECommerceProduct alloc] initWithSKU:product[@"sku"]
                                               name:product[@"name"]
                                 categoryComponents:product[@"categoryComponents"]
                                            payload:product[@"payload"]
                                        actualPrice:[self createPrice:product[@"actualPrice"]]
                                      originalPrice:[self createPrice:product[@"originalPrice"]]
                                         promoCodes:product[@"promoCodes"]];
}

- (YMMECommerceCartItem *)createCartItem:(NSDictionary *)cartItem  {
    YMMECommerceProduct *productObj = [self createProduct:cartItem[@"product"]];
    
    NSNumber *quantityNumber = cartItem[@"quantity"];
    if (quantityNumber == nil) {
        quantityNumber = [[NSNumber alloc] initWithInt:1];
    }
            
    YMMECommerceCartItem *item = [[YMMECommerceCartItem alloc] initWithProduct:productObj
                                                                      quantity:[NSDecimalNumber decimalNumberWithDecimal:quantityNumber.decimalValue]
                                                                       revenue:[self createPrice:cartItem[@"revenue"]]
                                                                      referrer:[self createReferrer:cartItem[@"referrer"]]];
    
    return item;
}

RCT_EXPORT_METHOD(showScreen:(NSDictionary *)screen) {
    YMMECommerceScreen *screenObj = [self createScreen:screen];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce showScreenEventWithScreen:screenObj] onFailure:nil];
}

RCT_EXPORT_METHOD(showProductCard:(NSDictionary *)product:(NSDictionary *)screen) {
    YMMECommerceProduct *productObj = [self createProduct:product];
    YMMECommerceScreen *screenObj = [self createScreen:screen];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce showProductCardEventWithProduct:productObj screen:screenObj]
                            onFailure:nil];
}

RCT_EXPORT_METHOD(showProductDetails:(NSDictionary *)product:(NSDictionary *)referrer) {
    [YMMYandexMetrica reportECommerce:[YMMECommerce showProductDetailsEventWithProduct:[self createProduct:product]
                                                                              referrer:[self createReferrer:referrer]]
                            onFailure:nil];
}

RCT_EXPORT_METHOD(addToCart:(NSDictionary *)cartItem) {
    YMMECommerceCartItem *item = [self createCartItem:cartItem];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce addCartItemEventWithItem:item] onFailure:nil];
}

RCT_EXPORT_METHOD(removeFromCart:(NSDictionary *)cartItem) {
    YMMECommerceCartItem *item = [self createCartItem:cartItem];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce removeCartItemEventWithItem:item] onFailure:nil];
}

RCT_EXPORT_METHOD(beginCheckout:(NSArray<NSDictionary *> *)cartItems identifier:(NSString *)identifier payload:(NSDictionary *)payload) {
    NSMutableArray *cartItemsObj = [[NSMutableArray alloc] init];
    for (int i = 0; i < cartItems.count; i++) {
        [cartItemsObj addObject:[self createCartItem:cartItems[i]]];
    }
    
    YMMECommerceOrder *order = [[YMMECommerceOrder alloc] initWithIdentifier:identifier
                                                                   cartItems:cartItemsObj
                                                                     payload:payload];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce beginCheckoutEventWithOrder:order] onFailure:nil];
}

RCT_EXPORT_METHOD(purchase:(NSArray<NSDictionary *> *)cartItems identifier:(NSString *)identifier payload:(NSDictionary *)payload) {
    NSMutableArray *cartItemsObj = [[NSMutableArray alloc] init];
    for (int i = 0; i < cartItems.count; i++) {
        [cartItemsObj addObject:[self createCartItem:cartItems[i]]];
    }
    
    YMMECommerceOrder *order = [[YMMECommerceOrder alloc] initWithIdentifier:identifier
                                                                   cartItems:cartItemsObj
                                                                     payload:payload];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce purchaseEventWithOrder:order] onFailure:nil];
}
///
/// End of E-Commerce
///

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
