import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/models/purchase_result.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';

import 'constants.dart';
import 'models/launch_result.dart';
import 'qa_provider.dart';

class Qonversion {
  static const MethodChannel _channel = MethodChannel('qonversion_flutter_sdk');

  /// Initializes Qonversion SDK with the given API key.
  /// You can get one in your account on qonversion.io.
  static Future<QLaunchResult> launch(
    String apiKey, {
    @required bool isObserveMode,
  }) async {
    final args = {
      Constants.kApiKey: apiKey,
      Constants.kObserveMode: isObserveMode,
    };
    final rawResult = await _channel.invokeMethod(Constants.mLaunch, args);

    return QLaunchResult.fromJson(Map<String, dynamic>.from(rawResult));
  }

  static Future<void> setUserId(String userId) =>
      _channel.invokeMethod(Constants.mSetUserId, {Constants.kUserId: userId});

  /// This method will send all purchases to the Qonversion backend. Call this every time when purchase is handled by you own implementation.
  ///
  /// **Warning!**
  ///
  /// This method works for Android only.
  /// It should only be called if you're using Qonversion SDK in observer mode.
  ///
  /// See [Observer mode for Android SDK](https://documentation.qonversion.io/docs/observer-mode#android-sdk-only)
  static Future<void> syncPurchases() {
    if (Platform.isAndroid) {
      return _channel.invokeMethod(Constants.mSyncPurchases);
    }

    return null;
  }

  /// Returns Qonversion Products in assoсiation with Google Play Store Products.
  ///
  /// See [Product Center](https://qonversion.io/docs/product-center)
  static Future<Map<String, QProduct>> products() async {
    final rawResult = await _channel.invokeMethod(Constants.mProducts);

    return QMapper.productsFromJson(rawResult);
  }

  /// Starts a process of purchasing product with [productId].
  static Future<QPurchaseResult> purchase(String productId) async {
    final rawResult = await _channel
        .invokeMethod(Constants.mPurchase, {Constants.kProductId: productId});

    final resultMap = Map<String, dynamic>.from(rawResult);

    if (resultMap['error'] != null) {
      throw Exception(resultMap['error']);
    }

    return QPurchaseResult.fromJson(resultMap);
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
