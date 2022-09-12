import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/models/offerings.dart';
import 'package:qonversion_flutter/src/models/user_property.dart';
import 'package:qonversion_flutter/src/models/permissions_cache_lifetime.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';
import 'package:qonversion_flutter/src/utils/string.dart';

import 'constants.dart';
import 'models/launch_result.dart';
import 'models/purchase_exception.dart';
import 'qa_provider.dart';

class Qonversion {
  static const String _sdkVersion = "4.4.0";

  static const MethodChannel _channel = MethodChannel('qonversion_flutter_sdk');

  static const _purchasesEventChannel =
      EventChannel('qonversion_flutter_updated_purchases');

  static const _promoPurchasesEventChannel =
      EventChannel('qonversion_flutter_promo_purchases');

  /// Yields an event each time a deferred transaction happens
  static Stream<Map<String, QPermission>> get updatedPurchasesStream =>
      _purchasesEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        final Map<String, dynamic> decodedEvent = jsonDecode(event);

        return decodedEvent
            .map((key, value) => MapEntry(key, QPermission.fromJson(value)));
      });

  /// Yields an event each time a promo transaction happens on iOS.
  /// Returns App Store product ID
  static Stream<String> get promoPurchasesStream =>
      _promoPurchasesEventChannel.receiveBroadcastStream().cast<String>();

  /// Initializes Qonversion SDK with the given API key.
  /// You can get one in your account on qonversion.io.
  static Future<QLaunchResult> launch(
    String apiKey, {
    required bool isObserveMode,
  }) async {
    _storeSdkInfo();

    final args = {
      Constants.kApiKey: apiKey,
      Constants.kObserveMode: isObserveMode,
    };
    final rawResult = await _channel.invokeMethod(Constants.mLaunch, args);

    final result = QLaunchResult.fromJson(Map<String, dynamic>.from(rawResult));
    return result;
  }

  /// Call this function to link a user to his unique ID in your system and share purchase data.
  /// [userId] unique user ID in your system
  static Future<void> identify(String userId) =>
      _channel.invokeMethod(Constants.mIdentify, {Constants.kUserId: userId});

  /// Call this function to unlink a user from his unique ID in your system and his purchase data.
  static Future<void> logout() => _channel.invokeMethod(Constants.mLogout);

  /// Call this function to reset user ID and generate new anonymous user ID.
  /// Call this function before Qonversion.launch()
  @Deprecated(
      "This function was used in debug mode only. You can reinstall the app if you need to reset the user ID.")
  static Future<void> resetUser() async {
    debugPrint(
        "resetUser() function is deprecated now. It was used in debug mode only. You can reinstall the app if you need to reset the user ID.");
  }

  /// This method will send all purchases to the Qonversion backend. Call this every time when purchase is handled by you own implementation.
  ///
  /// **Warning!**
  ///
  /// This method works for Android only.
  /// It should only be called if you're using Qonversion SDK in observer mode.
  ///
  /// See [Observer mode for Android SDK](https://documentation.qonversion.io/docs/observer-mode#android-sdk-only)
  static Future<void> syncPurchases() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod(Constants.mSyncPurchases);
    }
  }

  /// Returns Qonversion Products in assoсiation with Google Play Store Products.
  ///
  /// See [Product Center](https://qonversion.io/docs/product-center)
  static Future<Map<String, QProduct>> products() async {
    final rawResult = await _channel.invokeMethod(Constants.mProducts);

    final result = QMapper.productsFromJson(rawResult);
    return result;
  }

  /// Starts a process of purchasing product with [productId].
  ///
  /// Throws `QPurchaseException` in case of error in purchase flow.
  static Future<Map<String, QPermission>> purchase(String productId) async {
    try {
      final rawResult = await _channel
          .invokeMethod(Constants.mPurchase, {Constants.kProductId: productId});

      final result = QMapper.permissionsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  /// Starts a process of purchasing product with Qonversion's [product] object.
  ///
  /// Throws `QPurchaseException` in case of error in purchase flow.
  static Future<Map<String, QPermission>> purchaseProduct(
      QProduct product) async {
    try {
      final rawResult = await _channel.invokeMethod(
          Constants.mPurchaseProduct,
          {
            Constants.kProductId: product.qonversionId,
            Constants.kOfferingId: product.offeringID
          }
      );

      final result = QMapper.permissionsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  /// Android only. Returns `null` if called on iOS.
  ///
  /// Upgrading, downgrading, or changing a subscription on Google Play Store requires calling updatePurchase() function.
  ///
  /// See [Google Play Documentation](https://developer.android.com/google/play/billing/subscriptions#upgrade-downgrade) for more details.
  static Future<Map<String, QPermission>?> updatePurchase({
    required String newProductId,
    required String oldProductId,
    ProrationMode? prorationMode,
  }) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final rawResult = await _channel.invokeMethod(Constants.mUpdatePurchase, {
        Constants.kNewProductId: newProductId,
        Constants.kOldProductId: oldProductId,
        Constants.kProrationMode: prorationMode != null ? prorationMode.index : null,
      });
      final result = QMapper.permissionsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  /// Android only. Returns `null` if called on iOS.
  ///
  /// Upgrading, downgrading, or changing a subscription on Google Play Store requires calling updatePurchaseWithProduct() function.
  ///
  /// See [Google Play Documentation](https://developer.android.com/google/play/billing/subscriptions#upgrade-downgrade) for more details.
  static Future<Map<String, QPermission>?> updatePurchaseWithProduct({
    required QProduct newProduct,
    required String oldProductId,
    ProrationMode? prorationMode,
  }) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final rawResult = await _channel.invokeMethod(Constants.mUpdatePurchaseWithProduct, {
        Constants.kNewProductId: newProduct.qonversionId,
        Constants.kOfferingId: newProduct.offeringID,
        Constants.kOldProductId: oldProductId,
        Constants.kProrationMode: prorationMode != null ? prorationMode.index : null,
      });
      final result = QMapper.permissionsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  /// iOS only. Returns `null` if called on Android.
  /// Starts a promo purchase process with App Store [productId].
  ///
  /// Throws `QPurchaseException` in case of error in purchase flow.
  static Future<Map<String, QPermission>?> promoPurchase(
      String productId) async {
    if (!Platform.isIOS) {
      return null;
    }

    try {
      final rawResult = await _channel.invokeMethod(
          Constants.mPromoPurchase, {Constants.kProductId: productId});
      final result = QMapper.permissionsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  /// You need to call the checkPermissions method at the start of your app to check if a user has the required permission.
  ///
  /// This method will check the user receipt and will return the current permissions.
  ///
  /// If Apple or Google servers are not responding at the time of the request, Qonversion provides the latest permissions data from its database.
  static Future<Map<String, QPermission>> checkPermissions() async {
    final rawResult = await _channel.invokeMethod(Constants.mCheckPermissions);

    final result = QMapper.permissionsFromJson(rawResult);
    return result;
  }

  /// Restoring purchases restores users purchases in your app, to maintain access to purchased content.
  /// Users sometimes need to restore purchased content, such as when they upgrade to a new phone.
  static Future<Map<String, QPermission>> restore() async {
    final rawResult = await _channel.invokeMethod(Constants.mRestore);

    final result = QMapper.permissionsFromJson(rawResult);
    return result;
  }

  /// Qonversion SDK provides an asynchronous method to set your side User ID that can be used to match users in third-party integrations.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-identifiers)
  @Deprecated(
      "Will be removed in a future major release. Use setProperty(QUserProperty.customUserId, 'value') instead.")
  static Future<void> setUserId(String userId) =>
      setProperty(QUserProperty.customUserId, userId);

  /// Sets user property for pre-defined case property.
  ///
  /// User properties are attributes you can set on a user level.
  /// You can send user properties to third party platforms as well as use them in Qonversion for customer segmentation and analytics.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-properties)
  static Future<void> setProperty(QUserProperty property, String value) =>
      _channel.invokeMethod(Constants.mSetDefinedUserProperty, {
        Constants.kProperty: StringUtils.capitalize(describeEnum(property)),
        Constants.kValue: value,
      });

  /// Adds custom user property.
  ///
  /// User properties are attributes you can set on a user level.
  /// You can send user properties to third party platforms as well as use them in Qonversion for customer segmentation and analytics.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-properties)
  static Future<void> setUserProperty(String property, String value) =>
      _channel.invokeMethod(Constants.mSetCustomUserProperty, {
        Constants.kProperty: property,
        Constants.kValue: value,
      });

  /// Sends your attribution [data] to the [provider].
  ///
  /// [userId] parameter is deprecated and not used.
  static Future<void> addAttributionData(
    Map<dynamic, dynamic> data, {
    required QAttributionProvider provider,
    @deprecated String? userId,
  }) {
    final args = {
      Constants.kData: data,
      Constants.kProvider: StringUtils.capitalize(describeEnum(provider)),
    };

    return _channel.invokeMethod(Constants.mAddAttributionData, args);
  }

  /// You can set the flag to distinguish sandbox and production users.
  /// To see the sandbox users turn on the Viewing test Data toggle on Qonversion Dashboard
  static Future<void> setDebugMode() =>
      _channel.invokeMethod(Constants.mSetDebugMode);

  /// iOS only. Returns `null` if called on Android.
  /// On iOS 14.5+, after requesting the app tracking permission using ATT, you need to notify Qonversion if tracking is allowed and IDFA is available.
  static Future<void> setAdvertisingID() async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(Constants.mSetAdvertisingID);
    }
  }

  /// Return Qonversion Offerings Object
  /// An offering is a group of products that you can offer to a user on a given paywall based on your business logic.
  /// For example, you can offer one set of products on a paywall immediately after onboarding and another set of products with discounts later on if a user has not converted.
  /// Offerings allow changing the products offered remotely without releasing app updates.
  ///
  /// See [Offerings](https://qonversion.io/docs/offerings) for more details.
  /// See [Product Center](https://qonversion.io/docs/product-center) for more details.
  static Future<QOfferings> offerings() async {
    final offeringsString =
        await _channel.invokeMethod<String>(Constants.mOfferings);

    final result = QMapper.offeringsFromJson(offeringsString);
    return result;
  }

  /// You can check if a user is eligible for an introductory offer, including a free trial.
  /// You can show only a regular price for users who are not eligible for an introductory offer.
  /// [ids] products identifiers that must be checked
  static Future<Map<String, QEligibility>> checkTrialIntroEligibility(
      List<String> ids) async {
    final eligibilitiesString = await _channel.invokeMethod<String>(
        Constants.mCheckTrialIntroEligibility, {"ids": ids});

    final result = QMapper.eligibilityFromJson(eligibilitiesString);
    return result;
  }

  /// Enable attribution collection from Apple Search Ads. NO by default.
  static Future<void> setAppleSearchAdsAttributionEnabled(bool enable) async {
    if (!Platform.isIOS) {
      return null;
    }

    return _channel.invokeMethod(Constants.mSetAppleSearchAdsAttributionEnabled,
        {Constants.kEnableAppleSearchAdsAttribution: enable});
  }

  /// Permissions cache is used when there are problems with the Qonversion API
  /// or internet connection. If so, Qonversion will return the last successfully loaded
  /// permissions. The current method allows you to configure how long that cache may be used.
  /// The default value is [QPermissionsCacheLifetime.month].
  ///
  /// [lifetime] Desired permissions cache lifetime duration.
  static Future<void> setPermissionsCacheLifetime(QPermissionsCacheLifetime lifetime) =>
      _channel.invokeMethod(Constants.mSetPermissionsCacheLifetime, {
        Constants.kLifetime: StringUtils.capitalize(describeEnum(lifetime)),
      });

  /// Set push token to Qonversion to enable Qonversion push notifications
  /// [token] Firebase device token on Android. APNs device token on iOS
  static Future<void> setNotificationsToken(String token) {
    return _channel.invokeMethod(Constants.mSetNotificationsToken,
        {Constants.kNotificationsToken: token});
  }

  /// [notificationData] notification payload data
  /// See [Firebase RemoteMessage data](https://pub.dev/documentation/firebase_messaging_platform_interface/latest/firebase_messaging_platform_interface/RemoteMessage/data.html)
  /// See [APNs notification data](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649869-userinfo)
  /// Returns true when a push notification was received from Qonversion. Otherwise returns false, so you need to handle a notification yourself
  static Future<bool> handleNotification(Map<String, dynamic> notificationData) async {
    try {
      final bool rawResult = await _channel.invokeMethod(
          Constants.mHandleNotification,
          {Constants.kNotificationData: notificationData}) as bool;
      return rawResult;
    } catch (e) {
      return false;
    }
  }

  // Private methods
  static Future<void> _storeSdkInfo() =>
      _channel.invokeMethod(Constants.mStoreSdkInfo, {
        "version": _sdkVersion,
        "source": "flutter",
      });

  static QPurchaseException _convertPurchaseException(PlatformException error) {
    return QPurchaseException(
      error.code,
      error.message ?? "",
      error.details,
      isUserCancelled: error.code == "PurchaseCancelledByUser"
    );
  }
}
