/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.metrica.plugin.reactnative;

import com.facebook.react.bridge.Callback;
import com.yandex.metrica.AppMetricaDeviceIDListener;

public class ReactNativeAppMetricaDeviceIDListener implements AppMetricaDeviceIDListener {

    private final Callback listener;

    ReactNativeAppMetricaDeviceIDListener(Callback listener) {
        this.listener = listener;
    }

    @Override
    public void onLoaded(/* Nullable */ String deviceId) {
        listener.invoke(deviceId, null);
    }

    @Override
    public void onError(/* NonNull */ Reason reason) {
        listener.invoke(null, reason.toString());
    }
}
