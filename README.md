# react-native-appmetrica-next

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
    RNAppMetrica.setUserProfileID('id');
    RNAppMetrica.reportUserProfile({
      name: 'Andrey Bondarenko',
      floor: 'male',
      age: 34,
      isNotification: true,
    });

// init Push SDK example for iOS
 checkPermission = async () => {
    const authorizationStatus = await messaging().requestPermission();

    if (authorizationStatus === messaging.AuthorizationStatus.AUTHORIZED) {
      const deviceToken = await messaging().getToken();

      RNAppMetrica.initPush(deviceToken); -> // for iOS
      // or
      RNAppMetrica.initPush(); -> // for Android

```
