declare module 'react-native-appmetrica' {
    type AppMetricaConfig = {
      apiKey: string;
      appVersion?: string;
      crashReporting?: boolean;
      firstActivationAsUpdate?: boolean;
      location?: Location;
      locationTracking?: boolean;
      logs?: boolean;
      sessionTimeout?: number;
      statisticsSending?: boolean;
      preloadInfo?: PreloadInfo;
      // Only Android
      installedAppCollecting?: boolean;
      maxReportsInDatabaseCount?: number;
      nativeCrashReporting?: boolean;
      // Only iOS
      activationAsSessionStart?: boolean;
      sessionsAutoTracking?: boolean;
    };
  
    type PreloadInfo = {
      trackingId: string;
      additionalInfo?: Object;
    };
  
    type Location = {
      latitude: number;
      longitude: number;
      altitude?: number;
      accuracy?: number;
      course?: number;
      speed?: number;
      timestamp?: number;
    };
  
    type AppMetricaDeviceIdReason = 'UNKNOWN' | 'NETWORK' | 'INVALID_RESPONSE';
  
    function activate(config: AppMetricaConfig): void;
  
    // Android
    function getLibraryApiLevel(): Promise<number>;
  
    function getLibraryVersion(): Promise<string>;
  
    function pauseSession(): void;
  
    function reportAppOpen(deeplink?: string): void;
  
    function reportError(error: string, reason: Object): void;
  
    function reportEvent(eventName: string, attributes?: Object): void;
  
    function reportReferralUrl(referralUrl: string): void;
  
    function requestAppMetricaDeviceID(listener: (deviceId?: String, reason?: AppMetricaDeviceIdReason) => void): void;
  
    function resumeSession(): void;
  
    function sendEventsBuffer(): void;
  
    function setLocation(location?: Location): void;
  
    function setLocationTracking(enabled: boolean): void;
  
    function setStatisticsSending(enabled: boolean): any;
  
    function setUserProfileID(userProfileID?: string): void;
  }
  