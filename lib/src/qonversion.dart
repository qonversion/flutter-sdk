import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qonversion_flutter/src/serializer.dart';

import 'constants.dart';
import 'qa_provider.dart';

class Qonversion {
  static const MethodChannel _channel = MethodChannel('qonversion_flutter_sdk');

  /// **Warning**:
  /// On Android you will have to call `Qonversion.trackPurchase(details, purchase)` method to track all
  /// purchases manually.
  ///
  /// On iOS Qonversion will track any purchase events (trials, subscriptions, basic purchases) automatically.
  ///
  /// ================
  ///
  /// Initializes Qonversion SDK with the given API key.
  /// You can get one in your account on qonversion.io.
  /// If you're using different API keys for iOS and Android, please
  /// contact us at hi@qonversion.io since we [now can merge them into one](https://qonversion.io/docs/crossplatform-project).
  ///
  /// You can provide your own client-side [userId] if needed.
  ///
  /// Returns `userId` for Ads integrations.
  static Future<String> launch(
    String apiKey, {
    String userId,
  }) async {
    final args = {
      Constants.kApiKey: apiKey,
      Constants.kUserId: userId,
    };

    final uid = await _channel.invokeMethod(Constants.mLaunch, args);

    return uid;
  }

  /// This is a fallback method if you're not using [official in_app_purchase plugin](https://pub.dev/packages/in_app_purchase).
  ///
  /// Use it only if you have to build SkuDetails and PurchaseDetails maps manually on your side.
  ///
  /// Tracks purchases manually on Android.
  ///
  /// Returns `null` if `!Platform.isAndroid`.
  static Future<String> trackPurchase(Map<String, dynamic> skuDetails,
      Map<String, dynamic> purchaseDetails) async {
    if (!Platform.isAndroid) return null;

    final args = {
      Constants.kDetails: skuDetails,
      Constants.kPurchase: purchaseDetails,
    };

    return _channel.invokeMethod(Constants.mTrackPurchase, args);
  }

  /// Tracks purchases manually on Android.
  ///
  /// Returns `null` if `!Platform.isAndroid`.
  ///
  /// You have to use [official in_app_purchase plugin](https://pub.dev/packages/in_app_purchase) and instances of its
  /// [ProductDetails] and [PurchaseDetails] classes received on purchase success to track purchase with Qonversion.
  static Future<String> manualTrackPurchase(
      ProductDetails productDetails, PurchaseDetails purchaseDetails) async {
    if (!Platform.isAndroid) return null;

    final skuDetails = QDetailsSerializer.buildSkuMap(productDetails.skuDetail);
    final billingClientPurchaseDetails =
        QDetailsSerializer.buildPurchaseMap(purchaseDetails);

    final args = {
      Constants.kDetails: jsonEncode(skuDetails),
      Constants.kPurchase: jsonEncode(billingClientPurchaseDetails),
      Constants.kSignature: purchaseDetails.billingClientPurchase.signature,
    };

    return _channel.invokeMethod(Constants.mTrackPurchase, args);
  }

  /// Sends your attribution [data] to the [provider].
  ///
  /// [userId], if specified, will also be sent to the provider.
  /// Note that you can pass `null` as [userId] on iOS.
  ///
  /// On Android [userId] is non-nullable.
  static Future<void> addAttributionData(
    Map<dynamic, dynamic> data, {
    @required QAttributionProvider provider,
    @required String userId,
  }) {
    final args = {
      Constants.kData: data,
      Constants.kProvider: describeEnum(provider),
      Constants.kUserId: userId,
    };

    return _channel.invokeMethod(Constants.mAddAttributionData, args);
  }
}
