class Constants {
  // Params names
  static const kProjectKey = 'projectKey';
  static const kLaunchMode = 'launchMode';
  static const kEnvironment = 'environment';
  static const kEntitlementsCacheLifetime = 'entitlementsCacheLifetime';
  static const kUserId = 'userId';
  static const kData = 'data';
  static const kProvider = 'provider';
  static const kDetails = 'details';
  static const kProductId = 'productId';
  static const kOfferingId = 'offeringId';
  static const kNewProductId = 'newProductId';
  static const kOldProductId = 'oldProductId';
  static const kError = 'error';
  static const kIsCancelled = 'is_cancelled';
  static const kEntitlements = 'entitlements';
  static const kProperty = 'property';
  static const kValue = 'value';
  static const kProrationMode = 'proration_mode';
  static const kEnableAppleSearchAdsAttribution = 'enable';
  static const kNotificationsToken = 'notificationsToken';
  static const kNotificationData = 'notificationData';
  static const kLifetime = 'lifetime';

  // MethodChannel methods names
  static const mInitialize = 'initialize';
  static const mProducts = 'products';
  static const mPurchase = 'purchase';
  static const mPurchaseProduct = 'purchaseProduct';
  static const mPromoPurchase = 'promoPurchase';
  static const mUpdatePurchase = 'updatePurchase';
  static const mUpdatePurchaseWithProduct = 'updatePurchaseWithProduct';
  static const mCheckEntitlements = 'checkEntitlements';
  static const mRestore = 'restore';
  static const mSetDefinedUserProperty = 'setDefinedUserProperty';
  static const mSetCustomUserProperty = 'setCustomUserProperty';
  static const mSetEntitlementsCacheLifetime = 'setEntitlementsCacheLifetime';
  static const mSyncPurchases = 'syncPurchases';
  static const mAddAttributionData = 'addAttributionData';
  static const mSetDebugMode = 'setDebugMode';
  static const mSetAdvertisingID = 'setAdvertisingID';
  static const mOfferings = 'offerings';
  static const mCheckTrialIntroEligibility = 'checkTrialIntroEligibility';
  static const mStoreSdkInfo = 'storeSdkInfo';
  static const mIdentify = 'identify';
  static const mLogout = 'logout';
  static const mUserInfo = 'userInfo';
  static const mSetAppleSearchAdsAttributionEnabled =
      'setAppleSearchAdsAttributionEnabled';
  static const mSetNotificationsToken = 'setNotificationsToken';
  static const mHandleNotification = 'handleNotification';
  static const mGetNotificationCustomPayload = 'getNotificationCustomPayload';
  static const mPresentCodeRedemptionSheet = 'presentCodeRedemptionSheet';

  // Numeric constants
  static const skuDetailsPriceRatio = 1000000;
}
