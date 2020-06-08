/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import AppMetrica from 'react-native-appmetrica';

AppMetrica.activate({
  apiKey: ...Your_APIKey...,
});
try {
  callingNonExistentVariable;
} catch (e) {
  AppMetrica.reportError(e.message, e.stack);
}
AppMetrica.reportEvent('My event');

AppRegistry.registerComponent(appName, () => App);
