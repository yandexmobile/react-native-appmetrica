/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import {NativeModules} from 'react-native';

const {AppMetrica} = NativeModules;

type AppMetricaConfig = {
  apiKey: string,
  appVersion?: string,
  crashReporting?: boolean,
  firstActivationAsUpdate?: boolean,
  location: Location,
  locationTracking?: boolean,
  logs?: boolean,
  sessionTimeout?: number,
  statisticsSending?: boolean,
  preloadInfo?: PreloadInfo,
  // Only Android
  installedAppCollecting?: boolean,
  maxReportsInDatabaseCount?: number,
  nativeCrashReporting?: boolean,
  // Only iOS
  activationAsSessionStart?: boolean,
  sessionsAutoTracking?: boolean,
}

type PreloadInfo = {
  trackingId: string,
  additionalInfo?: Object,
}

type Location = {
  latitude: number,
  longitude: number,
  altitude?: number,
  accuracy?: number,
  course?: number,
  speed?: number,
  timestamp?: number
}

type AppMetricaDeviceIdReason = 'UNKNOWN' | 'NETWORK' | 'INVALID_RESPONSE';

type Currency = 'RUB' | 'USD' | 'EUR';
type Screen = {
  name?: string,
  categoryComponents?: string[],
  searchQuery?: string,
  payload?: Object,
}
type Product = {
  name?: string,
  sku: string,
  categoryComponents?: string[],
  payload?: Object,
  promoCodes?: string[],
  currency: Currency,
  actualPrice?: string,
  originalPrice?: string,
}
type Referrer = {
  screen: Screen,
  type: string,
  identifier: string,
}
type CartItem = {
  product: Product,
  quantity: number,
  revenue: number,
  referrer?: Referrer,
}

export default {

  activate(config: AppMetricaConfig) {
    AppMetrica.activate(config);
  },

  // Android
  async getLibraryApiLevel(): number {
    return AppMetrica.getLibraryApiLevel();
  },

  async getLibraryVersion(): string {
    return AppMetrica.getLibraryVersion();
  },

  pauseSession() {
    AppMetrica.pauseSession();
  },

  reportAppOpen(deeplink: ?string = null) {
    AppMetrica.reportAppOpen(deeplink);
  },

  reportError(error: string, reason: Object) {
    AppMetrica.reportError(error);
  },

  reportEvent(eventName: string, attributes: ?Object = null) {
    AppMetrica.reportEvent(eventName, attributes);
  },

  reportReferralUrl(referralUrl: string) {
    AppMetrica.reportReferralUrl(referralUrl);
  },

  // E-commerce
  showScreen(screen: Screen) {
    AppMetrica.showScreen(screen);
  },
  showProductCard(product: Product, screen: Screen) {
    AppMetrica.showProductCard(product, screen);
  },
  addToCart(cartItem: CartItem) {
    AppMetrica.addToCart(cartItem);
  },
  removeFromCart(cartItem: CartItem) {
    AppMetrica.removeFromCart(cartItem);
  },
  beginCheckout(cartItems: CartItem[], identifier: String, payload: Object) {
    AppMetrica.beginCheckout(cartItems, identifier, payload);
  },
  purchase(cartItems: CartItem[], identifier: String, payload: Object) {
    AppMetrica.purchase(cartItems, identifier, payload);
  },

  requestAppMetricaDeviceID(listener: (deviceId?: String, reason?: AppMetricaDeviceIdReason) => void) {
    AppMetrica.requestAppMetricaDeviceID(listener);
  },

  resumeSession() {
    AppMetrica.resumeSession();
  },

  sendEventsBuffer() {
    AppMetrica.sendEventsBuffer();
  },

  setLocation(location: ?Location) {
    AppMetrica.setLocation(location);
  },

  setLocationTracking(enabled: boolean) {
    AppMetrica.setLocationTracking(enabled);
  },

  setStatisticsSending(enabled: boolean) {
    AppMetrica.setStatisticsSending(enabled);
  },

  setUserProfileID(userProfileID?: string) {
    AppMetrica.setUserProfileID(userProfileID);
  },
};
