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

- (YMMECommerceProduct *)createProduct:(NSDictionary *)product {
    // TODO: internalComponents
    NSNumber *actualPriceNumber = product[@"actualPrice"];
    NSNumber *originalPriceNumber = product[@"originalPrice"];
    
    YMMECommercePrice *actualPrice, *originalPrice;
    
    if (actualPriceNumber != nil) {
        YMMECommerceAmount *actualFiat = [[YMMECommerceAmount alloc] initWithUnit:product[@"currency"] value:[NSDecimalNumber decimalNumberWithDecimal:actualPriceNumber.decimalValue]];
        actualPrice = [[YMMECommercePrice alloc] initWithFiat:actualFiat internalComponents:@[]]; // TODO:
    }
    if (originalPriceNumber != nil) {
        YMMECommerceAmount *originalFiat = [[YMMECommerceAmount alloc] initWithUnit:product[@"currency"] value:[NSDecimalNumber decimalNumberWithDecimal:originalPriceNumber.decimalValue]];
        originalPrice = [[YMMECommercePrice alloc] initWithFiat:originalFiat internalComponents:@[]]; // TODO:
    }
    
    YMMECommerceProduct *productObj = [[YMMECommerceProduct alloc] initWithSKU:product[@"sku"]
                                                                          name:product[@"name"]
                                                            categoryComponents:product[@"categoryComponents"]
                                                                       payload:product[@"payload"]
                                                                   actualPrice:actualPrice
                                                                 originalPrice:originalPrice
                                                                    promoCodes:product[@"promoCodes"]];
    
    return productObj;
}

- (YMMECommerceCartItem *)createCartItem:(NSDictionary *)cartItem  {
    YMMECommerceProduct *productObj = [self createProduct:cartItem[@"product"]];
    NSNumber *quantityNumber = cartItem[@"quantity"];
    NSNumber *revenueNumber = cartItem[@"revenue"];
        
    if (quantityNumber == nil) {
        quantityNumber = [[NSNumber alloc] initWithInt:1];
    }
    
    YMMECommercePrice *revenueObj;
    if (revenueNumber != nil) {
        YMMECommerceAmount *revenueFiat = [[YMMECommerceAmount alloc] initWithUnit:cartItem[@"product"][@"currency"] value:[NSDecimalNumber decimalNumberWithDecimal:revenueNumber.decimalValue]];
        revenueObj = [[YMMECommercePrice alloc] initWithFiat:revenueFiat];
    }
    
    NSDictionary *referrer = cartItem[@"referrer"];
    YMMECommerceReferrer *referrerObj;
    if (referrer != nil) {
        YMMECommerceScreen *screenObj = referrer[@"screen"] != nil ? [self createScreen:referrer[@"screen"]] : nil;
        referrerObj = [[YMMECommerceReferrer alloc] initWithType:referrer[@"type"]
                                                      identifier:referrer[@"identifier"]
                                                          screen:screenObj];
    }
    
    YMMECommerceCartItem *item = [[YMMECommerceCartItem alloc] initWithProduct:productObj
                                                                      quantity:[NSDecimalNumber decimalNumberWithDecimal:quantityNumber.decimalValue]
                                                                       revenue:revenueObj
                                                                      referrer:referrerObj];
    
    return item;
}

RCT_EXPORT_METHOD(showScreen:(NSDictionary *)screen) {
    YMMECommerceScreen *screenObj = [self createScreen:screen];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce showScreenEventWithScreen:screenObj] onFailure:nil];
}

RCT_EXPORT_METHOD(showProductCard:(NSDictionary *)product:(NSDictionary *)screen) {
    YMMECommerceProduct *productObj = [self createProduct:product];
    YMMECommerceScreen *screenObj = [self createScreen:screen];
    
    [YMMYandexMetrica reportECommerce:[YMMECommerce showProductCardEventWithProduct:productObj
                                                                             screen:screenObj]
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
