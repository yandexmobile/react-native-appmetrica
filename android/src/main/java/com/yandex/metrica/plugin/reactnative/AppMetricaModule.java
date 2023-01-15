/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.metrica.plugin.reactnative;

import android.app.Activity;
import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.yandex.metrica.YandexMetrica;
import com.yandex.metrica.ecommerce.ECommerceAmount;
import com.yandex.metrica.ecommerce.ECommerceCartItem;
import com.yandex.metrica.ecommerce.ECommerceEvent;
import com.yandex.metrica.ecommerce.ECommerceOrder;
import com.yandex.metrica.ecommerce.ECommercePrice;
import com.yandex.metrica.ecommerce.ECommerceProduct;
import com.yandex.metrica.ecommerce.ECommerceReferrer;
import com.yandex.metrica.ecommerce.ECommerceScreen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AppMetricaModule extends ReactContextBaseJavaModule {

    private static final String TAG = "AppMetricaModule";

    private final ReactApplicationContext reactContext;

    public AppMetricaModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "AppMetrica";
    }

    @ReactMethod
    public void activate(ReadableMap configMap) {
        YandexMetrica.activate(reactContext, Utils.toYandexMetricaConfig(configMap));
        enableActivityAutoTracking();
    }

    private void enableActivityAutoTracking() {
        Activity activity = getCurrentActivity();
        if (activity != null) { // TODO: check
            YandexMetrica.enableActivityAutoTracking(activity.getApplication());
        } else {
            Log.w(TAG, "Activity is not attached");
        }
    }

    @ReactMethod
    public void getLibraryApiLevel(Promise promise) {
        promise.resolve(YandexMetrica.getLibraryApiLevel());
    }

    @ReactMethod
    public void getLibraryVersion(Promise promise) {
        promise.resolve(YandexMetrica.getLibraryVersion());
    }

    @ReactMethod
    public void pauseSession() {
        YandexMetrica.pauseSession(getCurrentActivity());
    }

    @ReactMethod
    public void reportAppOpen(String deeplink) {
        YandexMetrica.reportAppOpen(deeplink);
    }

    @ReactMethod
    public void reportError(String message) {
        try {
            Integer.valueOf("00xffWr0ng");
        } catch (Throwable error) {
            YandexMetrica.reportError(message, error);
        }
    }

    @ReactMethod
    public void reportEvent(String eventName, ReadableMap attributes) {
        if (attributes == null) {
            YandexMetrica.reportEvent(eventName);
        } else {
            YandexMetrica.reportEvent(eventName, attributes.toHashMap());
        }
    }

    @ReactMethod
    public void reportReferralUrl(String referralUrl) {
        YandexMetrica.reportReferralUrl(referralUrl);
    }

    @ReactMethod
    public void requestAppMetricaDeviceID(Callback listener) {
        YandexMetrica.requestAppMetricaDeviceID(new ReactNativeAppMetricaDeviceIDListener(listener));
    }

    @ReactMethod
    public void resumeSession() {
        YandexMetrica.resumeSession(getCurrentActivity());
    }

    @ReactMethod
    public void sendEventsBuffer() {
        YandexMetrica.sendEventsBuffer();
    }

    @ReactMethod
    public void setLocation(ReadableMap locationMap) {
        YandexMetrica.setLocation(Utils.toLocation(locationMap));
    }

    @ReactMethod
    public void setLocationTracking(boolean enabled) {
        YandexMetrica.setLocationTracking(enabled);
    }

    @ReactMethod
    public void setStatisticsSending(boolean enabled) {
        YandexMetrica.setStatisticsSending(reactContext, enabled);
    }

    @ReactMethod
    public void setUserProfileID(String userProfileID) {
        YandexMetrica.setUserProfileID(userProfileID);
    }

    ///// E-commerce

    public ECommerceScreen createScreen(ReadableMap params) {
        if (params == null) return null;
        return new ECommerceScreen()
                .setName(params.getString("name"))
                .setCategoriesPath(Utils.toListString(params.getArray("categoryComponents")))
                .setSearchQuery(params.getString("searchQuery"))
                .setPayload(Utils.toMapString(params.getMap("payload")));
    }

    public ECommerceReferrer createReferrer(ReadableMap params) {
        if (params == null) return null;
        ECommerceScreen screen = this.createScreen(params.getMap("screen"));
        return new ECommerceReferrer()
                .setType(params.getString("type"))
                .setIdentifier(params.getString("identifier"))
                .setScreen(screen);
    }

    public ECommercePrice createPrice(ReadableMap params) {
        if (params == null) return null;
        ReadableMap fiatMap = params.getMap("fiat");
        ECommerceAmount fiat = new ECommerceAmount(fiatMap.getDouble("value"), fiatMap.getString("currency"));
        // TODO: internalComponents
        return new ECommercePrice(fiat);
    }

    public ECommerceProduct createProduct(ReadableMap params) {
        return new ECommerceProduct(params.getString("sku"))
                .setName(params.getString("name"))
                .setCategoriesPath(Utils.toListString(params.getArray("categoryComponents")))
                .setPayload(Utils.toMapString(params.getMap("payload")))
                .setActualPrice(this.createPrice(params.getMap("actualPrice")))
                .setOriginalPrice(this.createPrice(params.getMap("originalPrice")))
                .setPromocodes(Utils.toListString(params.getArray("promoCodes")));
    }

    public ECommerceCartItem createCartItem(ReadableMap params) {
        ECommerceProduct product = this.createProduct(params.getMap("product"));
        ECommercePrice revenue = this.createPrice(params.getMap("revenue"));
        ECommerceReferrer referrer = this.createReferrer(params.getMap("referrer"));

        return new ECommerceCartItem(product, revenue, params.getInt("quantity"))
                .setReferrer(referrer);
    }

    @ReactMethod
    public void showScreen(ReadableMap screenParams) {
        ECommerceScreen screen = this.createScreen(screenParams);
        ECommerceEvent showScreenEvent = ECommerceEvent.showScreenEvent(screen);
        YandexMetrica.reportECommerce(showScreenEvent);
    }

    @ReactMethod
    public void showProductCard(ReadableMap productParams, ReadableMap screenParams) {
        ECommerceProduct product = this.createProduct(productParams);
        ECommerceScreen screen = this.createScreen(screenParams);
        ECommerceEvent showProductCardEvent = ECommerceEvent.showProductCardEvent(product, screen);
        YandexMetrica.reportECommerce(showProductCardEvent);
    }

    @ReactMethod
    public void showProductDetails(ReadableMap productParams, ReadableMap referrerParams) {
        ECommerceProduct product = this.createProduct(productParams);
        ECommerceReferrer referrer = this.createReferrer(referrerParams);
        ECommerceEvent showProductDetailsEvent = ECommerceEvent.showProductDetailsEvent(product, referrer);
        YandexMetrica.reportECommerce(showProductDetailsEvent);
    }

    @ReactMethod
    public void addToCart(ReadableMap cartItemParams) {
        ECommerceCartItem cartItem = this.createCartItem(cartItemParams);
        ECommerceEvent addCartItemEvent = ECommerceEvent.addCartItemEvent(cartItem);
        YandexMetrica.reportECommerce(addCartItemEvent);
    }

    @ReactMethod
    public void removeFromCart(ReadableMap params) {
        ECommerceCartItem cartItem = this.createCartItem(params);
        ECommerceEvent removeCartItemEvent = ECommerceEvent.removeCartItemEvent(cartItem);
        YandexMetrica.reportECommerce(removeCartItemEvent);
    }

    @ReactMethod
    public void beginCheckout(ReadableArray cartItems, String identifier, ReadableMap payload) {
        ArrayList<ECommerceCartItem> cartItemsObj = new ArrayList<>();
        for (int i = 0; i < cartItemsObj.size(); i++) {
            cartItemsObj.add(this.createCartItem(cartItems.getMap(i)));
        }
        ECommerceOrder order = new ECommerceOrder(identifier, cartItemsObj)
                .setPayload(Utils.toMapString(payload));
        ECommerceEvent beginCheckoutEvent = ECommerceEvent.beginCheckoutEvent(order);
        YandexMetrica.reportECommerce(beginCheckoutEvent);
    }

    @ReactMethod
    public void purchase(ReadableArray cartItems, String identifier, ReadableMap payload) {
        ArrayList<ECommerceCartItem> cartItemsObj = new ArrayList<>();
        for (int i = 0; i < cartItemsObj.size(); i++) {
            cartItemsObj.add(this.createCartItem(cartItems.getMap(i)));
        }
        ECommerceOrder order = new ECommerceOrder(identifier, cartItemsObj)
                .setPayload(Utils.toMapString(payload));
        ECommerceEvent purchaseEvent = ECommerceEvent.purchaseEvent(order);
        YandexMetrica.reportECommerce(purchaseEvent);
    }
}
