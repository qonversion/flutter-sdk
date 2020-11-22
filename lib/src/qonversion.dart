import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'qa_provider.dart';

class Qonversion {
  static const MethodChannel _channel = MethodChannel('qonversion_flutter_sdk');

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
    final uid = await _channel.invokeMethod(Constants.mLaunch, apiKey);

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
