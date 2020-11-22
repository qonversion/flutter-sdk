import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
