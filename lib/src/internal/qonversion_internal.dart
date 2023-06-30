import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';
import 'package:qonversion_flutter/src/internal/utils/string.dart';

import 'constants.dart';

class QonversionInternal implements Qonversion {
  static const String _sdkVersion = "6.0.0";

  final MethodChannel _channel = MethodChannel('qonversion_plugin');

  final _updatedEntitlementsEventChannel =
      EventChannel('qonversion_flutter_updated_entitlements');

  final _promoPurchasesEventChannel =
      EventChannel('qonversion_flutter_promo_purchases');


  QonversionInternal(QonversionConfig config) {
    _storeSdkInfo();

    final args = {
      Constants.kProjectKey: config.projectKey,
      Constants.kLaunchMode: StringUtils.capitalize(describeEnum(config.launchMode)),
      Constants.kEnvironment: StringUtils.capitalize(describeEnum(config.environment)),
      Constants.kEntitlementsCacheLifetime: StringUtils.capitalize(describeEnum(config.entitlementsCacheLifetime)),
      Constants.kProxyUrl: config.proxyUrl,
      Constants.kKidsMode: config.kidsMode,
    };
    _channel.invokeMethod(Constants.mInitialize, args);
  }

  @override
  Stream<Map<String, QEntitlement>> get updatedEntitlementsStream =>
      _updatedEntitlementsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        final Map<String, dynamic> decodedEvent = jsonDecode(event);

        return decodedEvent
            .map((key, value) => MapEntry(key, QEntitlement.fromJson(value)));
      });

  @override
  Stream<String> get promoPurchasesStream =>
      _promoPurchasesEventChannel.receiveBroadcastStream().cast<String>();

  @override
  Future<void> syncHistoricalData() => _channel.invokeMethod(Constants.mSyncHistoricalData);

  @override
  Future<void> syncStoreKit2Purchases() async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(Constants.mSyncStoreKit2Purchases);
    }
  }

  @override
  Future<Map<String, QEntitlement>> purchase(String productId) async {
    try {
      final rawResult = await _channel
          .invokeMethod(Constants.mPurchase, {Constants.kProductId: productId});

      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>> purchaseProduct(QProduct product) async {
    try {
      final rawResult = await _channel.invokeMethod(
          Constants.mPurchaseProduct,
          {
            Constants.kProductId: product.qonversionId,
            Constants.kOfferingId: product.offeringID
          }
      );

      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>?> updatePurchase({
    required String newProductId,
    required String oldProductId,
    QProrationMode? prorationMode,
  }) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final rawResult = await _channel.invokeMethod(Constants.mUpdatePurchase, {
        Constants.kNewProductId: newProductId,
        Constants.kOldProductId: oldProductId,
        Constants.kProrationMode: prorationMode != null
            ? prorationMode.index
            : null,
      });
      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>?> updatePurchaseWithProduct({
    required QProduct newProduct,
    required String oldProductId,
    QProrationMode? prorationMode,
  }) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final rawResult = await _channel.invokeMethod(Constants.mUpdatePurchaseWithProduct, {
        Constants.kNewProductId: newProduct.qonversionId,
        Constants.kOfferingId: newProduct.offeringID,
        Constants.kOldProductId: oldProductId,
        Constants.kProrationMode: prorationMode != null
            ? prorationMode.index
            : null,
      });
      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QProduct>> products() async {
    final rawResult = await _channel.invokeMethod(Constants.mProducts);

    final result = QMapper.productsFromJson(rawResult);
    return result;
  }

  @override
  Future<QOfferings> offerings() async {
    final offeringsString = await _channel.invokeMethod<String>(Constants.mOfferings);

    final result = QMapper.offeringsFromJson(offeringsString);
    return result;
  }

  @override
  Future<Map<String, QEligibility>> checkTrialIntroEligibility(List<String> ids) async {
    final eligibilitiesString = await _channel.invokeMethod<String>(
        Constants.mCheckTrialIntroEligibility, {"ids": ids});

    final result = QMapper.eligibilityFromJson(eligibilitiesString);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>> checkEntitlements() async {
    final rawResult = await _channel.invokeMethod(Constants.mCheckEntitlements);

    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>> restore() async {
    final rawResult = await _channel.invokeMethod(Constants.mRestore);

    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<void> syncPurchases() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod(Constants.mSyncPurchases);
    }
  }

  @override
  Future<void> identify(String userId) =>
      _channel.invokeMethod(Constants.mIdentify, {Constants.kUserId: userId});

  @override
  Future<void> logout() => _channel.invokeMethod(Constants.mLogout);

  @override
  Future<QUser> userInfo() async {
    final rawResult = await _channel.invokeMethod(Constants.mUserInfo);

    final result = QMapper.userFromJson(rawResult);
    if (result == null) {
      throw new Exception("User deserialization failed");
    }
    return result;
  }

  @override
  Future<QRemoteConfig> remoteConfig() async {
    final rawResult = await _channel.invokeMethod(Constants.mRemoteConfig);

    final result = QMapper.remoteConfigFromJson(rawResult);
    if (result == null) {
      throw new Exception("Remote config deserialization failed");
    }
    return result;
  }

  @override
  Future<void> attachUserToExperiment(String experimentId, String groupId) async {
    final args = {
      Constants.kExperimentId: experimentId,
      Constants.kGroupId: groupId,
    };
    await _channel.invokeMethod(Constants.mAttachUserToExperiment, args);
    return;
  }

  @override
  Future<void> detachUserFromExperiment(String experimentId) async {
    final args = {
      Constants.kExperimentId: experimentId,
    };
    await _channel.invokeMethod(Constants.mDetachUserFromExperiment, args);
    return;
  }

  @override
  Future<void> attribution(Map<dynamic, dynamic> data, QAttributionProvider provider) {
    final args = {
      Constants.kData: data,
      Constants.kProvider: StringUtils.capitalize(describeEnum(provider)),
    };

    return _channel.invokeMethod(Constants.mAddAttributionData, args);
  }

  @override
  Future<void> setProperty(QUserProperty property, String value) =>
      _channel.invokeMethod(Constants.mSetDefinedUserProperty, {
        Constants.kProperty: StringUtils.capitalize(describeEnum(property)),
        Constants.kValue: value,
      });

  @override
  Future<void> setUserProperty(String property, String value) =>
      _channel.invokeMethod(Constants.mSetCustomUserProperty, {
        Constants.kProperty: property,
        Constants.kValue: value,
      });

  @override
  Future<void> collectAdvertisingId() async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(Constants.mCollectAdvertisingId);
    }
  }

  @override
  Future<void> collectAppleSearchAdsAttribution() async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(Constants.mCollectAppleSearchAdsAttribution);
    }
  }

  @override
  Future<void> presentCodeRedemptionSheet() async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(Constants.mPresentCodeRedemptionSheet);
    }
  }

  @override
  Future<Map<String, QEntitlement>?> promoPurchase(String productId) async {
    if (!Platform.isIOS) {
      return null;
    }

    try {
      final rawResult = await _channel.invokeMethod(
          Constants.mPromoPurchase, {Constants.kProductId: productId});
      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  // Private methods
  Future<void> _storeSdkInfo() =>
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
