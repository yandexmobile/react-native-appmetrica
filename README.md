# react-native-appmetrica
React Native bridge to the [AppMetrica](https://appmetrica.yandex.com/) on both iOS and Android.

###What's new here:
  - Upgraded Versions to 4.2.0
  - Supporting Apple Silicon M1 Macs
  - Supporting TypeScript

## Installation

1. `npm install react-native-appmetrica --save`
2. If React Native version <= 0.59: \
  `react-native link react-native-appmetrica`
3. iOS only
  * if `${PROJECT_DIR}/ios/Podfile` exists: \
  `npx pod-install`
  * if `${PROJECT_DIR}/ios/Podfile` don't exists: \
  [Setup AppMetrica](https://appmetrica.yandex.com/docs/mobile-sdk-dg/tasks/ios-quickstart.html) and placed frameworks at `${PROJECT_DIR}/ios/Frameworks`

## Usage

```js
import AppMetrica from '@gennadysx/react-native-appmetrica';

// Starts the statistics collection process.
AppMetrica.activate({
  apiKey: '...KEY...',
  sessionTimeout: 120,
  firstActivationAsUpdate: false,
});

// Sends a custom event message and additional parameters (optional).
AppMetrica.reportEvent('My event');
AppMetrica.reportEvent('My event', { foo: 'bar' });

// Send a custom error event.
AppMetrica.reportError('My error');
```
Modified with <span style="color: #e25555;">&#9829;</span> by GennadySX @2022
