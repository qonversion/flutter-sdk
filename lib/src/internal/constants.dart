class Constants {
  // Params names
  static const kProjectKey = 'projectKey';
  static const kLaunchMode = 'launchMode';
  static const kEnvironment = 'environment';
  static const kEntitlementsCacheLifetime = 'entitlementsCacheLifetime';
  static const kProxyUrl = 'proxyUrl';
  static const kKidsMode = 'kidsMode';
  static const kUserId = 'userId';
  static const kData = 'data';
  static const kProvider = 'provider';
  static const kDetails = 'details';
  static const kProductId = 'productId';
  static const kOfferId = 'offerId';
  static const kApplyOffer = 'applyOffer';
  static const kOfferingId = 'offeringId';
  static const kNewProductId = 'newProductId';
  static const kOldProductId = 'oldProductId';
  static const kUpdatePolicyKey = 'updatePolicyKey';
  static const kError = 'error';
  static const kIsCancelled = 'is_cancelled';
  static const kEntitlements = 'entitlements';
  static const kProperty = 'property';
  static const kValue = 'value';
  static const kNotificationsToken = 'notificationsToken';
  static const kNotificationData = 'notificationData';
  static const kLifetime = 'lifetime';
  static const kScreenId = 'screenId';
  static const kConfigData = 'configData';
  static const kExperimentId = 'experimentId';
  static const kGroupId = 'groupId';
  static const kRemoteConfigurationId = 'remoteConfigurationId';
  static const kContextKey = 'contextKey';
  static const kContextKeys = 'contextKeys';
  static const kPurchaseContextKeys = 'contextKeys';
  static const kPurchaseQuantity = 'quantity';
  static const kIncludeEmptyContextKey = 'includeEmptyContextKey';

  // MethodChannel methods names
  static const mInitialize = 'initialize';
  static const mSyncHistoricalData = 'syncHistoricalData';
  static const mSyncStoreKit2Purchases = 'syncStoreKit2Purchases';
  static const mProducts = 'products';
  static const mPurchase = 'purchase';
  static const mPromoPurchase = 'promoPurchase';
  static const mUpdatePurchase = 'updatePurchase';
  static const mCheckEntitlements = 'checkEntitlements';
  static const mRestore = 'restore';
  static const mSetDefinedUserProperty = 'setDefinedUserProperty';
  static const mSetCustomUserProperty = 'setCustomUserProperty';
  static const mUserProperties = 'userProperties';
  static const mSetEntitlementsCacheLifetime = 'setEntitlementsCacheLifetime';
  static const mSyncPurchases = 'syncPurchases';
  static const mAddAttributionData = 'addAttributionData';
  static const mSetDebugMode = 'setDebugMode';
  static const mCollectAdvertisingId = 'collectAdvertisingId';
  static const mIsFallbackFileAccessible = 'isFallbackFileAccessible';
  static const mOfferings = 'offerings';
  static const mCheckTrialIntroEligibility = 'checkTrialIntroEligibility';
  static const mStoreSdkInfo = 'storeSdkInfo';
  static const mIdentify = 'identify';
  static const mLogout = 'logout';
  static const mUserInfo = 'userInfo';
  static const mRemoteConfig = 'remoteConfig';
  static const mRemoteConfigList = 'remoteConfigList';
  static const mRemoteConfigListForContextKeys = 'remoteConfigListForContextKeys';
  static const mAttachUserToExperiment = 'attachUserToExperiment';
  static const mDetachUserFromExperiment = 'detachUserFromExperiment';
  static const mAttachUserToRemoteConfiguration = 'attachUserToRemoteConfiguration';
  static const mDetachUserFromRemoteConfiguration = 'detachUserFromRemoteConfiguration';
  static const mCollectAppleSearchAdsAttribution = 'collectAppleSearchAdsAttribution';
  static const mPresentCodeRedemptionSheet = 'presentCodeRedemptionSheet';
  static const mSubscribeAutomations = 'automationsSubscribe';
  static const mSetNotificationsToken = 'automationsSetNotificationsToken';
  static const mHandleNotification = 'automationsHandleNotification';
  static const mGetNotificationCustomPayload = 'automationsGetNotificationCustomPayload';
  static const mShowScreen = 'automationsShowScreen';
  static const mSetScreenPresentationConfig = 'setScreenPresentationConfig';

  // Numeric constants
  static const skuDetailsPriceRatio = 1000000;
}
