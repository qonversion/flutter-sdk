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

  /// Starts a process of purchasing product with [productId].
  ///
  /// Throws [QPurchaseException] in case of error in purchase flow.
  Future<Map<String, QEntitlement>> purchase(String productId);

  /// Starts a process of purchasing product with Qonversion's [product] object.
  ///
  /// Throws [QPurchaseException] in case of error in purchase flow.
  Future<Map<String, QEntitlement>> purchaseProduct(QProduct product);

  /// Android only. Returns `null` if called on iOS.
  ///
  /// Upgrading, downgrading, or changing a subscription on Google Play Store requires calling updatePurchase() function.
  ///
  /// See [Google Play Documentation](https://developer.android.com/google/play/billing/subscriptions#upgrade-downgrade) for more details.
  Future<Map<String, QEntitlement>?> updatePurchase({
    required String newProductId,
    required String oldProductId,
    QProrationMode? prorationMode,
  });

  /// Android only. Returns `null` if called on iOS.
  ///
  /// Upgrading, downgrading, or changing a subscription on Google Play Store requires calling updatePurchaseWithProduct() function.
  ///
  /// See [Google Play Documentation](https://developer.android.com/google/play/billing/subscriptions#upgrade-downgrade) for more details.
  Future<Map<String, QEntitlement>?> updatePurchaseWithProduct({
    required QProduct newProduct,
    required String oldProductId,
    QProrationMode? prorationMode,
  });

  /// Returns Qonversion Products in association with Google Play Store Products.
  ///
  /// See [Product Center](https://qonversion.io/docs/product-center)
  Future<Map<String, QProduct>> products();

  /// Return Qonversion Offerings Object
  /// An offering is a group of products that you can offer to a user on a given paywall based on your business logic.
  /// For example, you can offer one set of products on a paywall immediately after onboarding and another set of products with discounts later on if a user has not converted.
  /// Offerings allow changing the products offered remotely without releasing app updates.
  ///
  /// See [Offerings](https://qonversion.io/docs/offerings) for more details.
  /// See [Product Center](https://qonversion.io/docs/product-center) for more details.
  Future<QOfferings> offerings();

  /// You can check if a user is eligible for an introductory offer, including a free trial.
  /// You can show only a regular price for users who are not eligible for an introductory offer.
  /// [ids] products identifiers that must be checked
  Future<Map<String, QEligibility>> checkTrialIntroEligibility(
      List<String> ids);

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
  Future<void> identify(String userId);

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

  /// Returns Qonversion remote config object
  /// Use this function to get the remote config with specific payload and experiment info.
  Future<QRemoteConfig> remoteConfig();

  /// This function should be used for the test purposes only. Do not forget to delete the usage of this function before the release.
  /// Use this function to attach the user to the experiment.
  Future<void> attachUserToExperiment(String experimentId, String groupId);

  /// This function should be used for the test purposes only. Do not forget to delete the usage of this function before the release.
  /// Use this function to detach the user from the experiment.
  Future<void> detachUserFromExperiment(String experimentId);

  /// iOS only. Returns `null` if called on Android.
  ///
  /// Starts a promo purchase process with App Store [productId].
  ///
  /// Throws [QPurchaseException] in case of error in purchase flow.
  Future<Map<String, QEntitlement>?> promoPurchase(String productId);
}
