//
//  AppMetrica+Delegate.h
//  Pods
//
//  Created by Andrey Bondarenko on 16.02.2021.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

#ifndef AppMetrica_Delegate_h
#define AppMetrica_Delegate_h


#endif /* AppMetrica_Delegate_h */

@interface AppMetricaDelegateApp : NSObject <UIApplicationDelegate>

+ (_Nonnull instancetype)sharedInstance;

- (void)observe;


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;


@end
