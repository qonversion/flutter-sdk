import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum QAttributionProvider { appsFlyer, branch }

class Qonversion {
  static const MethodChannel _channel =
      const MethodChannel('qonversion_flutter_sdk');

  /// Launches Qonversion SDK with the given API keys for each platform:
  /// [androidApiKey] and [iosApiKey] respectively,
  /// you can get one in your account on qonversion.io.
  ///
  /// [onComplete] will return `uid` for Ads integrations.
  ///
  /// **Warning**:
  /// Qonversion will track any purchase events (trials, subscriptions, basic purchases) automatically.
  static Future<void> launchWith({
    String androidApiKey,
    String iosApiKey,
    void Function(String) onComplete,
  }) async {
    final key = _obtainPlatformApiKey(
        androidApiKey: androidApiKey, iosApiKey: iosApiKey);

    final args = {'key': key};
    final uid =
        await _channel.invokeMethod<String>('launchWithKeyCompletion', args);
    return onComplete(uid);
  }

  /// Launches Qonversion SDK with the given API keys for each platform:
  /// [androidApiKey] and [iosApiKey] respectively,
  /// you can get one in your account on qonversion.io.
  ///
  /// Sets client side [userid] (instead of Qonversion user-id) that will be used for matching data in the third party data.
  static Future<void> launchWithClientSideUserId(
    String userID, {
    String androidApiKey,
    String iosApiKey,
  }) async {
    final key = _obtainPlatformApiKey(
        androidApiKey: androidApiKey, iosApiKey: iosApiKey);

    final args = {
      'key': key,
      'userID': userID,
    };

    return await _channel.invokeMethod('launchWithKeyUserId', args);
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
  static Future<void> launchWithAutoTrackPurchases(
    bool autoTrackPurchases, {
    String androidApiKey,
    String iosApiKey,
    void Function(String) onComplete,
  }) async {
    final key = _obtainPlatformApiKey(
        androidApiKey: androidApiKey, iosApiKey: iosApiKey);

    final args = {
      'key': key,
      'autoTrackPurchases': autoTrackPurchases,
    };
    final uid = await _channel.invokeMethod<String>(
        'launchWithKeyAutoTrackPurchasesCompletion', args);
    return onComplete(uid);
  }

  /// Sends your attribution [data] to the [provider].
  ///
  /// [userID], if specified, will also be sent to the provider
  static Future<void> addAttributionData(
    Map<dynamic, dynamic> data,
    QAttributionProvider provider, {
    String userID,
  }) async {
    final args = {
      'data': data,
      'provider': describeEnum(provider),
      'userID': userID,
    };

    return await _channel.invokeMethod('addAttributionData', args);
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
