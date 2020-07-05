import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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

  /// Tracks purchases manually on Android.
  ///
  /// Returns `null` if `!Platform.isAndroid`.
  ///
  /// You can use [official in_app_purchase package](https://pub.dev/packages/in_app_purchase) and its
  /// [SkuDetailsWrapper](https://github.com/flutter/plugins/blob/master/packages/in_app_purchase/lib/src/billing_client_wrappers/sku_details_wrapper.dart)
  /// and [PurchaseWrapper](https://github.com/flutter/plugins/blob/master/packages/in_app_purchase/lib/src/billing_client_wrappers/purchase_wrapper.dart)
  /// to pass [details] and [purchase] arguments.
  Future<String> trackPurchase(
      Map<String, dynamic> details, Map<String, dynamic> purchase) async {
    if (!Platform.isAndroid) return null;

    final args = {
      Constants.kDetails: details,
      Constants.kPurchase: purchase,
    };

    final uid = await _channel.invokeMethod(Constants.mTrackPurchase, args);

    return uid;
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
