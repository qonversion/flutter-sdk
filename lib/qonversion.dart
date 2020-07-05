import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/constants.dart';

enum QAttributionProvider { appsFlyer, branch }

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
  /// Qonversion will track any purchase events (trials, subscriptions, basic purchases) automatically.
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

  Future<String> trackPurchase(
      Map<String, dynamic> details, Map<String, dynamic> purchase) async {
    final args = {
      Constants.kDetails: details,
      Constants.kPurchase: purchase,
    };

    final uid = await _channel.invokeMethod(Constants.mTrackPurchase, args);

    return uid;
  }

  /// Launches Qonversion SDK with the given API keys for each platform:
  /// [androidApiKey] and [iosApiKey] respectively,
  /// you can get one in your account on qonversion.io.
  ///
  /// [onComplete] will return `uid` for Ads integrations.
  ///
  /// **Warning**:
  /// Qonversion will track any purchase events (trials, subscriptions, basic purchases) automatically.
  @Deprecated("Use `launch` method instead")
  static Future<void> launchWith({
    String androidApiKey,
    String iosApiKey,
    void Function(String) onComplete,
  }) async {
    final key = _obtainPlatformApiKey(
      androidApiKey: androidApiKey,
      iosApiKey: iosApiKey,
    );

    final args = {Constants.kApiKey: key};
    final uid =
        await _channel.invokeMethod(Constants.mLaunchWithKeyCompletion, args);

    onComplete(uid);
  }

  /// Launches Qonversion SDK with the given API keys for each platform:
  /// [androidApiKey] and [iosApiKey] respectively,
  /// you can get one in your account on qonversion.io.
  ///
  /// Sets client side [userid] (instead of Qonversion user-id) that will be used for matching data in the third party data.
  @Deprecated("Use `launch` method instead")
  static Future<void> launchWithClientSideUserId(
    String userID, {
    String androidApiKey,
    String iosApiKey,
  }) {
    final key = _obtainPlatformApiKey(
        androidApiKey: androidApiKey, iosApiKey: iosApiKey);

    final args = {
      Constants.kApiKey: key,
      Constants.kUserId: userID,
    };

    return _channel.invokeMethod(Constants.mLaunchWithKeyUserId, args);
  }

  /// **Don't use with autoTrackPurchases: false** now.
  /// Functionality is under development yet.
  ///
  /// Launches Qonversion SDK with the given API keys for each platform:
  /// [androidApiKey] and [iosApiKey] respectively,
  /// you can get one in your account on qonversion.io.
  ///
  /// With [autoTrackPurchases] parameter turned off you need to call `trackPurchase:transaction:` method.
  /// [onComplete] will return `uid` for Ads integrations.
  /// **Warning**:
  /// Will track any purchase events (trials, subscriptions, basic purchases) automatically.
  /// But if `autoTrackPurchases` disabled you need to call `trackPurchase:transaction:` method (under development yet).
  /// Otherwise, purchases tracking won't work.
  @Deprecated("Use `launch` method instead")
  static Future<void> launchWithAutoTrackPurchases(
    bool autoTrackPurchases, {
    String androidApiKey,
    String iosApiKey,
    void Function(String) onComplete,
  }) async {
    final key = _obtainPlatformApiKey(
        androidApiKey: androidApiKey, iosApiKey: iosApiKey);

    final args = {
      Constants.kApiKey: key,
      Constants.kAutoTrackPurchases: autoTrackPurchases,
    };
    final uid = await _channel.invokeMethod<String>(
        Constants.mLaunchWithKeyAutoTrackPurchasesCompletion, args);

    onComplete(uid);
  }

  /// Sends your attribution [data] to the [provider].
  ///
  /// [userID], if specified, will also be sent to the provider
  static Future<void> addAttributionData(
      Map<dynamic, dynamic> data, QAttributionProvider provider) {
    final args = {
      Constants.kData: data,
      Constants.kProvider: describeEnum(provider),
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
