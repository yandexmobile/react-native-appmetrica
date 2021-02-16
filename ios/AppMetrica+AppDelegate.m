//
//  AppMetrica+Delegate.m
//  react-native-appmetrica-next
//
//  Created by Andrey Bondarenko on 16.02.2021.
//

#import <Foundation/Foundation.h>
#import "AppMetrica+AppDelegate.h"


@implementation AppMetricaDelegateApp

+ (instancetype)sharedInstance {
  static dispatch_once_t once;
  __strong static AppMetricaDelegateApp *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[AppMetricaDelegateApp alloc] init];
  });
  return sharedInstance;
}


- (void)observe {
  static dispatch_once_t once;
  __weak AppMetricaDelegateApp *weakSelf = self;
  dispatch_once(&once, ^{
      AppMetricaDelegateApp *strongSelf = weakSelf;


    SEL didReceiveRemoteNotificationWithCompletionSEL =
        NSSelectorFromString(@"application:didReceiveRemoteNotification:fetchCompletionHandler:");
  
  });
}


// called when `registerForRemoteNotifications` completes successfully
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken 41");
}

@end
