class Constants {
  // Params names
  static const kApiKey = 'key';
  static const kObserveMode = 'isObserveMode';
  static const kUserId = 'userId';
  static const kData = 'data';
  static const kProvider = 'provider';
  static const kDetails = 'details';
  static const kProductId = 'productId';
  static const kProduct = 'product';
  static const kNewProductId = 'newProductId';
  static const kOldProductId = 'oldProductId';
  static const kError = 'error';
  static const kIsCancelled = 'is_cancelled';
  static const kPermissions = 'permissions';
  static const kProperty = 'property';
  static const kValue = 'value';
  static const kProrationMode = 'proration_mode';
  static const kEnableAppleSearchAdsAttribution = 'enable';
  static const kNotificationsToken = 'notificationsToken';
  static const kNotificationData = 'notificationData';

  // MethodChannel methods names
  static const mLaunch = 'launch';
  static const mProducts = 'products';
  static const mPurchase = 'purchase';
  static const mPurchaseProduct = 'purchaseProduct';
  static const mPromoPurchase = 'promoPurchase';
  static const mUpdatePurchase = 'updatePurchase';
  static const mUpdatePurchaseWithProduct = 'updatePurchaseWithProduct';
  static const mCheckPermissions = 'checkPermissions';
  static const mRestore = 'restore';
  static const mSetUserId = 'setUserId';
  static const mSetProperty = 'setProperty';
  static const mSetUserProperty = 'setUserProperty';
  static const mSyncPurchases = 'syncPurchases';
  static const mAddAttributionData = 'addAttributionData';
  static const mSetDebugMode = 'setDebugMode';
  static const mSetAdvertisingID = 'setAdvertisingID';
  static const mOfferings = 'offerings';
  static const mCheckTrialIntroEligibility = 'checkTrialIntroEligibility';
  static const mStoreSdkInfo = 'storeSdkInfo';
  static const mIdentify = 'identify';
  static const mLogout = 'logout';
  static const mSetAppleSearchAdsAttributionEnabled =
      'setAppleSearchAdsAttributionEnabled';
  static const mSetNotificationsToken = 'setNotificationsToken';
  static const mHandleNotification = 'handleNotification';

  // Keys for NSUserDefaults on iOS and SharedPreferences on Android
  static const keyPrefix = 'com.qonversion.keys';
  static const sourceKey = '$keyPrefix.source';
  static const versionKey = '$keyPrefix.sourceVersion';

  // Numeric constants
  static const skuDetailsPriceRatio = 1000000;

  // Error fields
  static const errorCode = 'code';
  static const errorDescription = 'description';
  static const errorAdditionalMessage = 'additionalMessage';
}
