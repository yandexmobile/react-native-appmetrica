# react-native-appmetrica-next

WARNING!!!
ver 2.0 RN68 >=
ver 1.0.17 RN67 <=

React Native bridge to the [AppMetrica](https://appmetrica.yandex.com/) on both iOS and Android.
react-native-push-next library functionality is expanded [react-native-appmetrica](https://github.com/yandexmobile/react-native-appmetrica)

## Installation

`npm install react-native-appmetrica-next --save`
or
`yearn add react-native-appmetrica-next`

## Usage

```js
import AppMetrica from "react-native-appmetrica-next";

// Starts the statistics collection process.
AppMetrica.activate({
  apiKey: "...KEY...",
  sessionTimeout: 120,
  firstActivationAsUpdate: true,
});

// Sends a custom event message and additional parameters (optional).
AppMetrica.reportEvent("My event");
AppMetrica.reportEvent("My event", { foo: "bar" });

// Send a custom error event.
AppMetrica.reportError("My error");

// reportUserProfile
AppMetrica.activate({
  apiKey: "...KEY...",
  sessionTimeout: 120,
  firstActivationAsUpdate: true,
});
RNAppMetrica.setUserProfileID("id");
RNAppMetrica.reportUserProfile({
  name: "Andrey Bondarenko",
  floor: "male",
  age: 34,
  isNotification: true,
});
```

# SETTING PUSH SDK

## NEXT for Android

## create file FirebaseMessagingMasterService.java in you project

```js
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.yandex.metrica.push.firebase.MetricaMessagingService;

public class FirebaseMessagingMasterService extends FirebaseMessagingService {
@Override
public void onMessageReceived(RemoteMessage message) {
super.onMessageReceived(message);
// AppMetrica automatically recognizes its messages and processes them only.
new MetricaMessagingService().processPush(this, message);

        // Implement the logic for sending messages to other SDKs.
    }

}
```

## Your files to Android manifest

```js
<application>
  ...
  <service
    android:name=".FirebaseMessagingMasterService"
    android:enabled="true"
    android:exported="false"
  >
    <intent-filter android:priority="100">
      <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
  </service>
  <service
    android:name="com.yandex.metrica.push.firebase.MetricaMessagingService"
    tools:node="remove"
  />
  ...
</application>
```

## Silent Push Notifications for Android

## create file BroadcastReceiver in you project

```js
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.yandex.metrica.push.YandexMetricaPush;


public class SilentPushReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO: This method is called when the BroadcastReceiver is receiving
        // an Intent broadcast.
        String payload = intent.getStringExtra(YandexMetricaPush.EXTRA_PAYLOAD);

        throw new UnsupportedOperationException("Not yet implemented");
    }
}
```

## Your files to Android manifest

```js
<application>
  ...
 <receiver android:name=".SilentPushReceiver">
            <intent-filter>
                <!-- Receive silent push notifications. -->
                <action android:name="${applicationId}.action.ymp.SILENT_PUSH_RECEIVE"/>
            </intent-filter>
        </receiver>
```

# NEXT for iOS

### file AppDelegate.m add

```js
// Add import
#import <YandexMobileMetricaPush/YMPYandexMetricaPush.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...
  ...
  // Enable in-app push notifications handling in iOS 10
      if ([UNUserNotificationCenter class] != nil) {
          id<YMPUserNotificationCenterDelegate> delegate = [YMPYandexMetricaPush userNotificationCenterDelegate];
          delegate.nextDelegate = [UNUserNotificationCenter currentNotificationCenter].delegate;
          [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
      }

    [YMPYandexMetricaPush handleApplicationDidFinishLaunchingWithOptions:launchOptions];
...
...
}

// and ADD
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [YMPYandexMetricaPush handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [YMPYandexMetricaPush handleRemoteNotification:userInfo];
}

...
...
@end
```

## Usage (FIREBASE CLOUD MESSAGE)

```js
import AppMetrica from "react-native-appmetrica-next";

// init Push SDK example for iOS
 checkPermission = async () => {
    const authorizationStatus = await messaging().requestPermission();

    if (authorizationStatus === messaging.AuthorizationStatus.AUTHORIZED) {
      const deviceToken = await messaging().getToken();

      RNAppMetrica.initPush();

```
