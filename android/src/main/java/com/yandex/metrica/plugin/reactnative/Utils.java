/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.metrica.plugin.reactnative;

import android.location.Location;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.yandex.metrica.PreloadInfo;
import com.yandex.metrica.YandexMetricaConfig;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

abstract class Utils {

    static YandexMetricaConfig toYandexMetricaConfig(ReadableMap configMap) {
        YandexMetricaConfig.Builder builder = YandexMetricaConfig.newConfigBuilder(configMap.getString("apiKey"));

        if (configMap.hasKey("appVersion")) {
            builder.withAppVersion(configMap.getString("appVersion"));
        }
        if (configMap.hasKey("crashReporting")) {
            builder.withCrashReporting(configMap.getBoolean("crashReporting"));
        }
        if (configMap.hasKey("firstActivationAsUpdate")) {
            builder.handleFirstActivationAsUpdate(configMap.getBoolean("firstActivationAsUpdate"));
        }
        if (configMap.hasKey("location")) {
            builder.withLocation(toLocation(configMap.getMap("location")));
        }
        if (configMap.hasKey("locationTracking")) {
            builder.withLocationTracking(configMap.getBoolean("locationTracking"));
        }
        if (configMap.hasKey("logs") && configMap.getBoolean("logs")) {
            builder.withLogs();
        }
        if (configMap.hasKey("maxReportsInDatabaseCount")) {
            builder.withMaxReportsInDatabaseCount(configMap.getInt("maxReportsInDatabaseCount"));
        }
        if (configMap.hasKey("nativeCrashReporting")) {
            builder.withNativeCrashReporting(configMap.getBoolean("nativeCrashReporting"));
        }
        if (configMap.hasKey("preloadInfo")) {
            builder.withPreloadInfo(toPreloadInfo(configMap.getMap("preloadInfo")));
        }
        if (configMap.hasKey("sessionTimeout")) {
            builder.withSessionTimeout(configMap.getInt("sessionTimeout"));
        }
        if (configMap.hasKey("statisticsSending")) {
            builder.withStatisticsSending(configMap.getBoolean("statisticsSending"));
        }

        return builder.build();
    }

    static Location toLocation(ReadableMap locationMap) {
        if (locationMap == null) {
            return null;
        }

        Location location = new Location("Custom");

        if (locationMap.hasKey("latitude")) {
            location.setLatitude(locationMap.getDouble("latitude"));
        }
        if (locationMap.hasKey("longitude")) {
            location.setLongitude(locationMap.getDouble("longitude"));
        }
        if (locationMap.hasKey("altitude")) {
            location.setAltitude(locationMap.getDouble("altitude"));
        }
        if (locationMap.hasKey("accuracy")) {
            location.setAccuracy((float) locationMap.getDouble("accuracy"));
        }
        if (locationMap.hasKey("course")) {
            location.setBearing((float) locationMap.getDouble("course"));
        }
        if (locationMap.hasKey("speed")) {
            location.setSpeed((float) locationMap.getDouble("speed"));
        }
        if (locationMap.hasKey("timestamp")) {
            location.setTime((long) locationMap.getDouble("timestamp"));
        }

        return location;
    }

    private static PreloadInfo toPreloadInfo(ReadableMap preloadInfoMap) {
        if (preloadInfoMap == null) {
            return null;
        }

        PreloadInfo.Builder builder = PreloadInfo.newBuilder(preloadInfoMap.getString("trackingId"));

        if (preloadInfoMap.hasKey("additionalInfo")) {
            ReadableMap additionalInfo = preloadInfoMap.getMap("additionalInfo");
            if (additionalInfo != null) {
                for (Map.Entry<String, Object> entry : additionalInfo.toHashMap().entrySet()) {
                    Object value = entry.getValue();
                    builder.setAdditionalParams(entry.getKey(), value == null ? null : value.toString());
                }
            }
        }

        return builder.build();
    }

    static List<String> toListString(ReadableArray readableArray) {
        if (readableArray == null) return null;
        ArrayList<Object> list = readableArray.toArrayList();
        List<String> strings = new ArrayList<>(list.size());
        for (Object object : list) {
            strings.add(Objects.toString(object, null));
        }
        return strings;
    }

    static Map<String, String> toMapString(ReadableMap readableMap) {
        if (readableMap == null) return null;
        Map<String, Object> map = readableMap.toHashMap();
        Map<String, String> newMap = new HashMap<String, String>();
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (entry.getValue() instanceof String) {
                newMap.put(entry.getKey(), (String) entry.getValue());
            }
        }
        return newMap;
    }
}
