/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import React, {Component, useState} from 'react';
import {StyleSheet, Text, View, ScrollView, SafeAreaView} from 'react-native';

import AppMetrica from 'react-native-appmetrica';

function getRactNativeVersion() {
  const reactNativePackage = require('./node_modules/react-native/package.json');
  return reactNativePackage.version;
}

function isReactNativeVersion(major, minor = 0, path = 0) {
  const {curMajor, curMinor, curPath} = getRactNativeVersion()
    .split('.')
    .map(it => +it);
  if (curMajor === major) {
    if (curMinor === minor) {
      return curPath >= path;
    }
    return curMinor > minor;
  }
  return curMajor > major;
}

type Props = {};
export default class App extends Component<Props> {
  constructor() {
    super();
    if (isReactNativeVersion(0, 60)) {
      const [appMetricaVersion, setAppMetricaVersion] = useState('???');
      const [appMetricaDeviceId, setAppMetricaDeviceId] = useState('???');
      AppMetrica.getLibraryVersion().then(version => {
        setAppMetricaVersion(version);
      });
      AppMetrica.requestAppMetricaDeviceID((deviceId, reason) => {
        setAppMetricaDeviceId(reason != null ? reason : deviceId);
      });
    } else {
      this.state = {appMetricaVersion: '???', appMetricaDeviceId: '???'};
      AppMetrica.getLibraryVersion().then(version => {
        this.setState({appMetricaVersion: version});
      });
      AppMetrica.requestAppMetricaDeviceID((deviceId, reason) => {
        this.setState({appMetricaDeviceId: reason != null ? reason : deviceId});
      });
    }
  }

  render() {
    return (
      <SafeAreaView>
        <ScrollView>
          <View style={styles.body}>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>React Native Version</Text>
              <Text style={styles.sectionDescription}>
                {getRactNativeVersion()}
              </Text>
            </View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>AppMetrica Version</Text>
              <Text style={styles.sectionDescription}>
                {isReactNativeVersion(0, 60)
                  ? this.appMetricaVersion
                  : this.state['appMetricaVersion']}
              </Text>
            </View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>AppMetrica DeviceId</Text>
              <Text style={styles.sectionDescription}>
                {isReactNativeVersion(0, 60)
                  ? this.appMetricaDeviceId
                  : this.state['appMetricaDeviceId']}
              </Text>
            </View>
          </View>
        </ScrollView>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  body: {
    backgroundColor: '#FFFFFF',
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: '#000000',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: '#050C00',
  },
});
