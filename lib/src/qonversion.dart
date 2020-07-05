import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'qa_provider.dart';

class Qonversion {
  static const MethodChannel _channel =
      const MethodChannel('qonversion_flutter_sdk');

  /// Launches Qonversion SDK with the given API keys for each platform:
  /// [androidApiKey] and [iosApiKey] respectively,
  /// you can get one in your account on qonversion.io.
  ///
  /// Returns `userId` for Ads integrations.
  ///
  /// **Warning**:
  /// On iOS Qonversion will track any purchase events (trials, subscriptions, basic purchases) automatically.
  ///
  /// On Android you will have to call `Qonversion.trackPurchase(details, purchase)` method to track all
  /// purchases manually.
  static Future<String> launch({
    @required String androidApiKey,
    @required String iosApiKey,
    String userId,
  }) async {
    final apiKey = _obtainPlatformApiKey(
      androidApiKey: androidApiKey,
      iosApiKey: iosApiKey,
    );

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

  static String _obtainPlatformApiKey({
    String androidApiKey,
    String iosApiKey,
  }) {
    String key;

    if (Platform.isAndroid) {
      key = androidApiKey;
    } else if (Platform.isIOS) {
      key = iosApiKey;
    } else {
      throw Exception('Unsupported platform');
    }

    if (key == null) {
      throw Exception(
          'Please provide API key for the platform you are running an app on');
    }

    return key;
  }
}
