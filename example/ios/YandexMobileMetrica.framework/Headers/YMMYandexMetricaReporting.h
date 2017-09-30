/*
 *  YMMYandexMetricaReporting.h
 *
 * This file is a part of the AppMetrica
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** YMMYandexMetricaReporting protocol groups methods that are used by custom reporting objects.
 */
@protocol YMMYandexMetricaReporting <NSObject>

/** Reporting custom event.

 @param name Short name or description of the event.
 @param onFailure Block to be executed if an error occurres while reporting, the error is passed as block argument.
 */
- (void)reportEvent:(NSString *)name
          onFailure:(nullable void (^)(NSError *error))onFailure;

/** Reporting custom event with additional parameters.

 @param name Short name or description of the event.
 @param params Dictionary of name/value pairs that must be sent to the server.
 @param onFailure Block to be executed if an error occurres while reporting, the error is passed as block argument.
 */
- (void)reportEvent:(NSString *)name
         parameters:(nullable NSDictionary *)params
          onFailure:(nullable void (^)(NSError *error))onFailure;

/** Reporting custom error messages.

 @param name Short name or description of the error.
 @param exception NSException object that must be sent to the server.
 @param onFailure Block to be executed if an error occurres while reporting, the error is passed as block argument.
 */
- (void)reportError:(NSString *)name
          exception:(nullable NSException *)exception
          onFailure:(nullable void (^)(NSError *error))onFailure;

/** Resumes last session or creates a new one if it has been expired.
 Should be used when auto tracking of application state is unavailable or is different.
 */
- (void)resumeSession;

/** Pause current session.
 All events reported after calling this method and till the session timeout will still join this session.
 Should be used when auto tracking of application state is unavailable or is different.
 */
- (void)pauseSession;

@end

NS_ASSUME_NONNULL_END
