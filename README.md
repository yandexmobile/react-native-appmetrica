[![Build Status](https://travis-ci.org/doochik/react-native-appmetrica.svg?branch=master)](https://travis-ci.org/doochik/react-native-appmetrica)
[![NPM version](https://badge.fury.io/js/react-native-appmetrica.svg)](https://www.npmjs.com/package/react-native-appmetrica)


# react-native-appmetrica
React Native bridge to the [AppMetrica](https://appmetrica.yandex.com/) on both iOS and Android.

## Installation

1. **Only for iOS**: [setup AppMetrica](https://tech.yandex.com/appmetrica/).
`YandexMobileMetrica.framework` should be placed at `<project_dir>/ios/` or `<project_dir>/ios/Frameworks/`.
Otherwise you'll get build error.
2. `npm install --save react-native-appmetrica`
3. `react-native link react-native-appmetrica`

**iOS notice**: If you build failed after installing SDK and `react-native-appmetrica`
make sure `YandexMobileMetrica.framework` and `libRCTAppMetrica.a` are included at Build Phase -> Link Binary With Libraries

## Example

```js
import AppMetrica from 'react-native-appmetrica';

AppMetrica.activateWithApiKey('2dee16d2-1143-4cd3-a904-39ce10ac2755');

AppMetrica.reportEvent('Hello world');
```

## Usage

```js
import AppMetrica from 'react-native-appmetrica';

// Start the statistics collection process.
AppMetrica.activateWithApiKey('...KEY...');
// OR
AppMetrica.activateWithConfig({
  apiKey: '...KEY...',
  sessionTimeout: 120,
  firstActivationAsUpdate: true,
});

// Send a custom event message and additional parameters (optional).
AppMetrica.reportEvent('My event');
AppMetrica.reportEvent('My event', { foo: 'bar' });

// Send a custom error event.
AppMetrica.reportError('My error');

// Send user profile with predefined attributes.
AppMetrica.reportUserProfile({ name: 'User 1', age: 87 });

// Send user profile with custom attributes.
AppMetrica.reportUserProfile({
  likesMusic: true,
  addedToFavorites: '+1',
  score: 150,
});
```
### Reporting user profile

All predefined attributes are supported. Use `null` to reset them.

```js
type UserProfileAttributes = {
    name?: ?string,
    gender?: 'female' | 'male' | string | void,
    age?: ?number,
    birthDate?: Date | [number] | [number, number] | [number, number, number] | void,
    notificationsEnabled?: boolean,
    /** custom attributes */
    [string]: string | number | boolean,
};
```

Custom attributes are supported. They can't be reset for now.

Use values like `'+1'`, `'-10'` for counters. Current limitation is any custom attribute which value started with `'+'` or `'-'` will be considered as a counter.

