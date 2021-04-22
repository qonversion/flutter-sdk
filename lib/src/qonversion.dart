import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/models/offerings.dart';
import 'package:qonversion_flutter/src/models/user_property.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';
import 'package:qonversion_flutter/src/utils/string.dart';

import 'constants.dart';
import 'models/launch_result.dart';
import 'models/purchase_exception.dart';
import 'qa_provider.dart';

class Qonversion {
  static const String _sdkVersion = "3.0.0";

  static const MethodChannel _channel = MethodChannel('qonversion_flutter_sdk');
  static const _purchasesEventChannel =
      EventChannel('qonversion_flutter_updated_purchases');

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

    return QLaunchResult.fromJson(Map<String, dynamic>.from(rawResult));
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

    return QMapper.productsFromJson(rawResult);
  }

  /// Starts a process of purchasing product with [productId].
  ///
  /// Throws `QPurchaseException` in case of error in purchase flow.
  static Future<Map<String, QPermission>> purchase(String productId) async {
    final rawResult = await _channel
        .invokeMethod(Constants.mPurchase, {Constants.kProductId: productId});

    final resultMap = Map<String, dynamic>.from(rawResult);

    final error = resultMap[Constants.kError];
    if (error != null) {
      throw QPurchaseException(
        error,
        isUserCancelled: resultMap[Constants.kIsCancelled] ?? false,
      );
    }

    return QMapper.permissionsFromJson(resultMap[Constants.kPermissions]);
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

    final rawResult = await _channel.invokeMethod(Constants.mUpdatePurchase, {
      Constants.kNewProductId: newProductId,
      Constants.kOldProductId: oldProductId,
      Constants.kProrationMode: prorationMode != null ? prorationMode.index : null,

    });
    return QMapper.permissionsFromJson(rawResult);
  }

  /// You need to call the checkPermissions method at the start of your app to check if a user has the required permission.
  ///
  /// This method will check the user receipt and will return the current permissions.
  ///
  /// If Apple or Google servers are not responding at the time of the request, Qonversion provides the latest permissions data from its database.
  static Future<Map<String, QPermission>> checkPermissions() async {
    final rawResult = await _channel.invokeMethod(Constants.mCheckPermissions);

    return QMapper.permissionsFromJson(rawResult);
  }

  /// Restoring purchases restores users purchases in your app, to maintain access to purchased content.
  /// Users sometimes need to restore purchased content, such as when they upgrade to a new phone.
  static Future<Map<String, QPermission>> restore() async {
    final rawResult = await _channel.invokeMethod(Constants.mRestore);

    return QMapper.permissionsFromJson(rawResult);
  }

  /// Qonversion SDK provides an asynchronous method to set your side User ID that can be used to match users in third-party integrations.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-identifiers)
  static Future<void> setUserId(String userId) =>
      _channel.invokeMethod(Constants.mSetUserId, {Constants.kUserId: userId});

  /// Sets user property for pre-defined case property.
  ///
  /// User properties are attributes you can set on a user level.
  /// You can send user properties to third party platforms as well as use them in Qonversion for customer segmentation and analytics.
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/user-properties)
  static Future<void> setProperty(QUserProperty property, String value) =>
      _channel.invokeMethod(Constants.mSetProperty, {
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
      _channel.invokeMethod(Constants.mSetUserProperty, {
        Constants.kProperty: property,
        Constants.kValue: value,
      });

  /// Sends your attribution [data] to the [provider].
  ///
  /// [userId], if specified, will also be sent to the provider.
  /// Note that you can pass `null` as [userId] on iOS.
  ///
  /// On Android [userId] is non-nullable.
  static Future<void> addAttributionData(
    Map<dynamic, dynamic> data, {
    required QAttributionProvider provider,
    required String userId,
  }) {
    final args = {
      Constants.kData: data,
      Constants.kProvider: describeEnum(provider),
      Constants.kUserId: userId,
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
        await (_channel.invokeMethod<String>(Constants.mOfferings) as FutureOr<String>);

    final Map<String, dynamic> decodedOfferings = jsonDecode(offeringsString);

    return QOfferings.fromJson(decodedOfferings);
  }

  /// You can check if a user is eligible for an introductory offer, including a free trial.
  /// You can show only a regular price for users who are not eligible for an introductory offer.
  /// [ids] products identifiers that must be checked
  static Future<Map<String, QEligibility>> checkTrialIntroEligibility(
      List<String> ids) async {
    final eligibilitiesString = await (_channel.invokeMethod<String>(
        Constants.mCheckTrialIntroEligibility, {"ids": ids}) as FutureOr<String>);

    final Map<String, dynamic> decodedEligibilities =
        jsonDecode(eligibilitiesString);

    return decodedEligibilities
        .map((key, value) => MapEntry(key, QEligibility.fromJson(value)));
  }

  // Private methods
  static Future<void> _storeSdkInfo() =>
      _channel.invokeMethod(Constants.mStoreSdkInfo, {
        "version": _sdkVersion,
        "versionKey": Constants.versionKey,
        "source": "flutter",
        "sourceKey": Constants.sourceKey
      });
}
