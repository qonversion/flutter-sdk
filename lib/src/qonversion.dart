import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'internal/qonversion_internal.dart';

abstract class Qonversion {
  static Qonversion? _backingInstance;

  /// Use this variable to get a current initialized instance of the Qonversion SDK.
  /// Please, use the property only after calling [Qonversion.initialize].
  /// Otherwise, trying to access the variable will cause an exception.
  ///
  /// Returns current initialized instance of the Qonversion SDK.
  /// Throws exception if the instance has not been initialized
  static Qonversion getSharedInstance() {
    Qonversion? instance = _backingInstance;

    if (instance == null) {
      throw new Exception("Qonversion has not been initialized. You should call " +
          "the initialize method before accessing the shared instance of Qonversion.");
    }

    return instance;
  }

  /// An entry point to use Qonversion SDK. Call to initialize Qonversion SDK with required and extra configs.
  /// The function is the best way to set additional configs you need to use Qonversion SDK.
  /// You still have an option to set a part of additional configs later via calling separate setters.
  ///
  /// [config] a config that contains key SDK settings.
  /// Call [QonversionConfigBuilder.build] to configure and create a [QonversionConfig] instance.
  /// Returns initialized instance of the Qonversion SDK.
  static Qonversion initialize(QonversionConfig config) {
    Qonversion instance = new QonversionInternal(config);
    _backingInstance = instance;
    return instance;
  }

  /// Yields an event each time user entitlements update.
  /// For example, when pending purchases like SCA, Ask to buy, etc., happen.
  Stream<Map<String, QEntitlement>> get updatedEntitlementsStream;

  /// Yields an event each time a promo transaction happens on iOS.
  /// Returns App Store product ID
  Stream<String> get promoPurchasesStream;

  /// Call this function to sync the subscriber data with the first launch when Qonversion is implemented.
  Future<void> syncHistoricalData();

  /// iOS only
  /// Contact us before you start using this function
  /// Call this function to sync purchases if you are using StoreKit2 and our SDK in Analytics mode.
  Future<void> syncStoreKit2Purchases();

  /// iOS only.
  /// Retrieve the promotional offer for the [product] and the product [discount] if it exists.
  /// Make sure to call this function before displaying product details to the user.
  /// The generated signature for the promotional offer is valid for a single transaction.
  /// If the purchase fails, you need to call this function again to obtain a new promotional offer signature.
  /// Use this signature to complete the purchase through the purchase function, along with the purchase options object.
  /// Returns the promise with the [QPromotionalOffer].
  Future<QPromotionalOffer?> getPromotionalOffer(QProduct product, SKProductDiscount discount);

  /// Make a purchase and validate it through server-to-server using Qonversion's Backend.
  /// This method returns a [QPurchaseResult] containing detailed information about the purchase,
  /// including the status, entitlements, error (if any), and store transaction details.
  ///
  /// [product] product to purchase.
  /// [options] additional options for the purchase process.
  ///
  /// Returns [QPurchaseResult] containing:
  /// - [QPurchaseResult.status] - the status of the purchase (success, userCanceled, pending, error)
  /// - [QPurchaseResult.entitlements] - the user's entitlements after the purchase
  /// - [QPurchaseResult.error] - error details if the purchase failed
  /// - [QPurchaseResult.storeTransaction] - raw store transaction information
  ///
  /// Unlike [purchaseProduct], this method does not throw exceptions for purchase errors.
  /// Instead, check [QPurchaseResult.status] to determine the outcome.
  ///
  /// See [Making Purchases](https://documentation.qonversion.io/docs/making-purchases)
  Future<QPurchaseResult> purchaseWithResult(QProduct product, {QPurchaseOptions? purchaseOptions});

  /// Make a purchase and validate it through server-to-server using Qonversion's Backend.
  /// [purchaseModel] necessary information for purchase.
  ///
  /// Returns the promise with the user entitlements including the ones obtained by the purchase.
  /// Throws [QPurchaseException] in case of error in purchase flow.
  ///
  /// See [Making Purchases](https://documentation.qonversion.io/docs/making-purchases)
  @Deprecated('Use purchaseWithResult instead')
  Future<Map<String, QEntitlement>> purchase(QPurchaseModel purchaseModel);

  /// Make a purchase and validate it through server-to-server using Qonversion's Backend
  /// [product] product to purchase.
  /// [options] additional options for the purchase process.
  /// Returns the promise with the user entitlements including the ones obtained by the purchase.
  /// Throws [QPurchaseException] in case of error in purchase flow.
  @Deprecated('Use purchaseWithResult instead')
  Future<Map<String, QEntitlement>> purchaseProduct(QProduct product, {QPurchaseOptions? purchaseOptions});

  /// Android only. Returns `null` if called on iOS.
  ///
  /// Update (upgrade/downgrade) subscription on Google Play Store and validate it through server-to-server using Qonversion's Backend
  ///
  /// [purchaseUpdateModel] necessary information for purchase update
  ///
  /// Returns the promise with the user entitlements including updated ones.
  /// Throws [QPurchaseException] in case of error in purchase flow.
  ///
  /// See [Update policy](https://developer.android.com/google/play/billing/subscriptions#replacement-modes)
  /// See [Making Purchases](https://documentation.qonversion.io/docs/making-purchases)
  Future<Map<String, QEntitlement>?> updatePurchase(QPurchaseUpdateModel purchaseUpdateModel);

  /// Returns Qonversion Products in association with Google Play Store Products.
  Future<Map<String, QProduct>> products();

  /// Return Qonversion Offerings Object
  /// An offering is a group of products that you can offer to a user on a given paywall based on your business logic.
  /// For example, you can offer one set of products on a paywall immediately after onboarding and another set of products with discounts later on if a user has not converted.
  /// Offerings allow changing the products offered remotely without releasing app updates.
  ///
  /// See [Offerings](https://qonversion.io/docs/offerings) for more details.
  Future<QOfferings> offerings();

  /// You can check if a user is eligible for an introductory offer, including a free trial.
  /// You can show only a regular price for users who are not eligible for an introductory offer.
  /// [ids] products identifiers that must be checked
  Future<Map<String, QEligibility>> checkTrialIntroEligibility(
      List<String> ids
  );

  /// You need to call the checkEntitlements method at the start of your app to check if a user has the required entitlement.
  ///
  /// This method will check the user receipt and will return the current entitlements.
  ///
  /// If Apple or Google servers are not responding at the time of the request, Qonversion provides the latest entitlements data from its database.
  Future<Map<String, QEntitlement>> checkEntitlements();

  /// Restoring purchases restores users purchases in your app, to maintain access to purchased content.
  /// Users sometimes need to restore purchased content, such as when they upgrade to a new phone.
  Future<Map<String, QEntitlement>> restore();

  /// Android only. Does nothing if called on iOS.
  ///
  /// This method will send all purchases to the Qonversion backend. Call this every time when purchase is handled by you own implementation.
  ///
  /// It should only be called if you're using Qonversion SDK in observer mode.
  ///
  /// See [Observer mode for Android SDK](https://documentation.qonversion.io/docs/observer-mode#android-sdk-only)
  Future<void> syncPurchases();

  /// Call this function to link a user to his unique ID in your system and share purchase data.
  /// [userId] unique user ID in your system
  Future<QUser> identify(String userId);

  /// Call this function to unlink a user from his unique ID in your system and his purchase data.
  Future<void> logout();

  /// This method returns information about the current Qonversion user.
  Future<QUser> userInfo();

  /// Sends your attribution [data] to the [provider].
  Future<void> attribution(Map<dynamic, dynamic> data, QAttributionProvider provider);

  /// Sets Qonversion reserved user properties, like email or user id.
  ///
  /// User properties are attributes you can set on a user level.
  /// You can send user properties to third party platforms as well as use them in Qonversion for customer segmentation and analytics.
  ///
  /// Note that using [QUserPropertyKey.custom] here will do nothing.
  /// To set custom user property, use [setCustomUserProperty] method instead.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-properties)
  Future<void> setUserProperty(QUserPropertyKey key, String value);

  /// Adds custom user property.
  ///
  /// User properties are attributes you can set on a user level.
  /// You can send user properties to third party platforms as well as use them in Qonversion for customer segmentation and analytics.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-properties)
  Future<void> setCustomUserProperty(String key, String value);

  /// This method returns all the properties, set for the current Qonversion user.
  /// All set properties are sent to the server with delay, so if you call
  /// this function right after setting some property, it may not be included
  /// in the result.
  Future<QUserProperties> userProperties();

  /// iOS only. Does nothing, if called on Android.
  ///
  /// On iOS 14.5+, after requesting the app tracking entitlement using ATT, you need to notify Qonversion if tracking is allowed and IDFA is available.
  Future<void> collectAdvertisingId();

  /// iOS only. Does nothing, if called on Android.
  ///
  /// Enable attribution collection from Apple Search Ads.
  Future<void> collectAppleSearchAdsAttribution();

  /// iOS only. Does nothing, if called on Android.
  ///
  /// On iOS 14.0+ shows up a sheet for users to redeem AppStore offer codes.
  Future<void> presentCodeRedemptionSheet();

  /// Returns Qonversion remote config object by [contextKey] or default one if the key is not specified.
  /// Use this function to get the remote config with specific payload and experiment info.
  Future<QRemoteConfig> remoteConfig({String? contextKey});

  /// Returns Qonversion remote config objects for all existing context key (including empty one).
  /// Use this function to get the remote configs with specific payload and experiment info.
  Future<QRemoteConfigList> remoteConfigList();

  /// Returns Qonversion remote config objects for a list of [contextKeys].
  /// Set [includeEmptyContextKey] to true if you want to include remote config with empty context key to the result.
  /// Use this function to get the remote configs with specific payload and experiment info.
  Future<QRemoteConfigList> remoteConfigListForContextKeys(
      List<String> contextKeys,
      bool includeEmptyContextKey
  );

  /// This function should be used for the test purposes only. Do not forget to delete the usage of this function before the release.
  /// Use this function to attach the user to the experiment.
  Future<void> attachUserToExperiment(String experimentId, String groupId);

  /// This function should be used for the test purposes only. Do not forget to delete the usage of this function before the release.
  /// Use this function to detach the user from the experiment.
  Future<void> detachUserFromExperiment(String experimentId);

  /// This function should be used for the test purposes only. Do not forget to delete the usage of this function before the release.
  /// Use this function to attach the user to the remote configuration.
  Future<void> attachUserToRemoteConfiguration(String remoteConfigurationId);

  /// This function should be used for the test purposes only. Do not forget to delete the usage of this function before the release.
  /// Use this function to detach the user from the remote configuration.
  Future<void> detachUserFromRemoteConfiguration(String remoteConfigurationId);

  /// Call this function to check if the fallback file is accessible.
  /// Returns flag that indicates whether Qonversion was able to read data from the fallback file or not.
  Future<bool> isFallbackFileAccessible();

  /// iOS only. Returns `null` if called on Android.
  ///
  /// Starts a promo purchase process with App Store [productId].
  ///
  /// Throws [QPurchaseException] in case of error in purchase flow.
  Future<Map<String, QEntitlement>?> promoPurchase(String productId);
}
