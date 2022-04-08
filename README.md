# @gennadysx/react-native-appmetrica
React Native bridge to the [AppMetrica](https://appmetrica.yandex.com/) on both iOS and Android.<br/>
This package forked from [RNAppMetrica](https://github.com/yandex/react-native-appmetrica) for modification to newer rn versions.

### What's new here:
  - Upgraded Native versions to 4.2.0
  - Support for Apple Silicon M1 Macs
  - Support for TypeScript
  - Supports only above v0.63.4
---
## Installation

1. `npm install @gennadysx/react-native-appmetrica --save`
2. If React Native version <= 0.63.4: \
  `react-native link @gennadysx/react-native-appmetrica`
3. iOS only
  * if `${PROJECT_DIR}/ios/Podfile` exists: \
  `npx pod-install`
  * if `${PROJECT_DIR}/ios/Podfile` don't exists: \
  [Setup AppMetrica](https://appmetrica.yandex.com/docs/mobile-sdk-dg/tasks/ios-quickstart.html) and placed frameworks at `${PROJECT_DIR}/ios/Frameworks`
---
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

---

Origin [Yandex AppMetrica](https://github.com/yandex/react-native-appmetrica). Modified with <span style="color: #e25555;">&#9829;</span> by GennadySX @2022. 
