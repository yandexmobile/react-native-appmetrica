# react-native-appmetrica-next

React Native bridge to the [AppMetrica](https://appmetrica.yandex.com/) on both iOS and Android.
react-native-push-next library functionality is expanded [react-native-appmetrica](https://github.com/yandexmobile/react-native-appmetrica)

## Installation

`npm install react-native-appmetrica-next --save`
or
`yearn add react-native-appmetrica-next`

1. If React Native version <= 0.59: \
   `react-native link react-native-appmetrica-next`
2. iOS only

- if `${PROJECT_DIR}/ios/Podfile` exists: \
  `npx pod-install`
- if `${PROJECT_DIR}/ios/Podfile` don't exists: \
  [Setup AppMetrica](https://appmetrica.yandex.com/docs/mobile-sdk-dg/tasks/ios-quickstart.html) and placed frameworks at `${PROJECT_DIR}/ios/Frameworks`

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
```
