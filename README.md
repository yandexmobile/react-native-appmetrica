# rn-yandex-appmetrica
React Native bridge to the [AppMetrica](https://appmetrica.yandex.com/) on both iOS and Android.

## About package
This is a temporary solution. This repository includes pull requests from the [main repository](https://github.com/yandexmobile/react-native-appmetrica) and will be supported until all critical updates are included. Added updates:
1. [Typescript support](https://github.com/yandexmobile/react-native-appmetrica/pull/46)
2. [Fix android build](https://github.com/yandexmobile/react-native-appmetrica/pull/62)
3. [EAS build support](https://github.com/yandexmobile/react-native-appmetrica/pull/65)

## Installation

 ```shell
  yarn add rn-yandex-appmetrica
 ```
## Integration into a pure React Native project

1. `npm install react-native-appmetrica --save`
2. If React Native version <= 0.59: \
  `react-native link react-native-appmetrica`
3. iOS only
  * if `${PROJECT_DIR}/ios/Podfile` exists: \
  `npx pod-install`
  * if `${PROJECT_DIR}/ios/Podfile` don't exists: \
  [Setup AppMetrica](https://appmetrica.yandex.com/docs/mobile-sdk-dg/tasks/ios-quickstart.html) and placed frameworks at `${PROJECT_DIR}/ios/Frameworks`

## Integrate into an Expo managed project

 1. Install `expo-dev-client`:

 ```shell
 expo install expo-dev-client
 ```

 1. Add `rn-yandex-appmetrica` into the `plugins` array inside the `app.json` file of your app:

 ```shell
 "plugins": [
   ["rn-yandex-appmetrica", {}],
 ],
 ```

## Usage

```js
import AppMetrica from 'rn-yandex-appmetrica';

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
