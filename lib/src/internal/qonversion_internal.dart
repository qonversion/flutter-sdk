import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';
import 'package:qonversion_flutter/src/internal/utils/string.dart';

import 'constants.dart';

class QonversionInternal implements Qonversion {
  static const String sdkVersion = "11.0.0";

  final MethodChannel _channel = MethodChannel('qonversion_plugin');

  final _updatedEntitlementsEventChannel =
      EventChannel('qonversion_flutter_updated_entitlements');

  final _promoPurchasesEventChannel =
      EventChannel('qonversion_flutter_promo_purchases');


  QonversionInternal(QonversionConfig config) {
    _storeSdkInfo();

    final args = {
      Constants.kProjectKey: config.projectKey,
      Constants.kLaunchMode: StringUtils.capitalize(config.launchMode.name),
      Constants.kEnvironment: StringUtils.capitalize(config.environment.name),
      Constants.kEntitlementsCacheLifetime: StringUtils.capitalize(config.entitlementsCacheLifetime.name),
      Constants.kProxyUrl: config.proxyUrl,
      Constants.kKidsMode: config.kidsMode,
    };
    // Initialize is fire-and-forget, errors will be handled in subsequent calls
    _channel.invokeMethod(Constants.mInitialize, args).catchError((error) {
      developer.log(
        'Failed to initialize Qonversion: $error',
        name: 'QonversionFlutter',
        error: error,
      );
    });
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
  Future<void> syncHistoricalData() async {
    return await _invokeMethod(Constants.mSyncHistoricalData);
  }

  @override
  Future<void> syncStoreKit2Purchases() async {
    if (Platform.isIOS) {
      return await _invokeMethod(Constants.mSyncStoreKit2Purchases);
    }
  }

  @override
  Future<QPromotionalOffer?> getPromotionalOffer(QProduct product, SKProductDiscount discount) async {
    if (Platform.isAndroid) {
      return null;
    }

    final promotionalOfferJson = await _invokeMethod(
      Constants.mGetPromotionalOffer, {
        Constants.kProductId: product.qonversionId,
        Constants.kDiscountId: discount.identifier,
      }
    );

    final result = QMapper.promotionalOfferFromJson(promotionalOfferJson);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>> purchase(QPurchaseModel purchaseModel) async {
    final rawResult = await _invokePurchaseMethod(Constants.mPurchase, {
      Constants.kProductId: purchaseModel.productId,
      Constants.kOfferId: purchaseModel.offerId,
      Constants.kApplyOffer: purchaseModel.applyOffer
    });

    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>> purchaseProduct(QProduct product, {QPurchaseOptions? purchaseOptions}) async {
    if (purchaseOptions == null) {
      purchaseOptions = new QPurchaseOptionsBuilder().build();
    }

    final Map<String, dynamic> promoOfferData = new Map<String, dynamic>();
    if (purchaseOptions.promotionalOffer != null) {
      promoOfferData['productDiscountId'] = purchaseOptions.promotionalOffer?.productDiscount.identifier;
      promoOfferData['keyIdentifier'] = purchaseOptions.promotionalOffer?.paymentDiscount.keyIdentifier;
      promoOfferData['nonce'] = purchaseOptions.promotionalOffer?.paymentDiscount.nonce;
      promoOfferData['signature'] = purchaseOptions.promotionalOffer?.paymentDiscount.signature;
      promoOfferData['timestamp'] = purchaseOptions.promotionalOffer?.paymentDiscount.timestamp;
    }

    final updatePolicy = purchaseOptions.updatePolicy;
    final rawResult = await _invokePurchaseMethod(Constants.mPurchase, {
      Constants.kProductId: product.qonversionId,
      Constants.kOldProductId: purchaseOptions.oldProduct?.qonversionId,
      Constants.kOfferId: purchaseOptions.offerId,
      Constants.kApplyOffer: purchaseOptions.applyOffer,
      Constants.kUpdatePolicyKey: updatePolicy != null
          ? StringUtils.capitalize(updatePolicy.name)
          : null,
      Constants.kPurchaseContextKeys: purchaseOptions.contextKeys,
      Constants.kPurchaseQuantity: purchaseOptions.quantity,
      Constants.kPromoOffer: promoOfferData,
    });

    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>?> updatePurchase(QPurchaseUpdateModel purchaseUpdateModel) async {
    if (!Platform.isAndroid) {
      return null;
    }

    final updatePolicy = purchaseUpdateModel.updatePolicy;

    final rawResult = await _invokePurchaseMethod(Constants.mUpdatePurchase, {
      Constants.kProductId: purchaseUpdateModel.productId,
      Constants.kOfferId: purchaseUpdateModel.offerId,
      Constants.kApplyOffer: purchaseUpdateModel.applyOffer,
      Constants.kOldProductId: purchaseUpdateModel.oldProductId,
      Constants.kUpdatePolicyKey: updatePolicy != null
          ? StringUtils.capitalize(updatePolicy.name)
          : null,
    });
    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<Map<String, QProduct>> products() async {
    final rawResult = await _invokeMethod(Constants.mProducts);

    final result = QMapper.productsFromJson(rawResult);
    return result;
  }

  @override
  Future<QOfferings> offerings() async {
    final offeringsString = await _invokeMethod(Constants.mOfferings) as String;

    final result = QMapper.offeringsFromJson(offeringsString);
    return result;
  }

  @override
  Future<Map<String, QEligibility>> checkTrialIntroEligibility(List<String> ids) async {
    final eligibilitiesString = await _invokeMethod(
        Constants.mCheckTrialIntroEligibility, {"ids": ids}) as String;

    final result = QMapper.eligibilityFromJson(eligibilitiesString);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>> checkEntitlements() async {
    final rawResult = await _invokeMethod(Constants.mCheckEntitlements);

    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<Map<String, QEntitlement>> restore() async {
    final rawResult = await _invokeMethod(Constants.mRestore);

    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  @override
  Future<void> syncPurchases() async {
    if (Platform.isAndroid) {
      return await _invokeMethod(Constants.mSyncPurchases);
    }
  }

  @override
  Future<QUser> identify(String userId) async {
    final rawResult = await _invokeMethod(Constants.mIdentify, {Constants.kUserId: userId});

    final result = QMapper.userFromJson(rawResult);
    if (result == null) {
      throw QonversionException(
        QErrorCode.internalError.code,
        "User deserialization failed",
        null,
      );
    }
    return result;
  }

  @override
  Future<void> logout() async {
    return await _invokeMethod(Constants.mLogout);
  }

  @override
  Future<QUser> userInfo() async {
    final rawResult = await _invokeMethod(Constants.mUserInfo);

    final result = QMapper.userFromJson(rawResult);
    if (result == null) {
      throw QonversionException(
        QErrorCode.internalError.code,
        "User deserialization failed",
        null,
      );
    }
    return result;
  }

  @override
  Future<QRemoteConfig> remoteConfig({String? contextKey}) async {
    final args = {
      Constants.kContextKey: contextKey,
    };
    final rawResult = await _invokeMethod(Constants.mRemoteConfig, args);

    final result = QMapper.remoteConfigFromJson(rawResult);
    if (result == null) {
      throw QonversionException(
        QErrorCode.internalError.code,
        "Remote config deserialization failed",
        null,
      );
    }
    return result;
  }

  @override
  Future<QRemoteConfigList> remoteConfigList() async {
    final rawResult = await _invokeMethod(Constants.mRemoteConfigList);

    final result = QMapper.remoteConfigListFromJson(rawResult);
    if (result == null) {
      throw QonversionException(
        QErrorCode.internalError.code,
        "Remote config list deserialization failed",
        null,
      );
    }
    return result;
  }

  @override
  Future<QRemoteConfigList> remoteConfigListForContextKeys(
      List<String> contextKeys,
      bool includeEmptyContextKey
  ) async {
    final args = {
      Constants.kContextKeys: contextKeys,
      Constants.kIncludeEmptyContextKey: includeEmptyContextKey,
    };
    final rawResult = await _invokeMethod(Constants.mRemoteConfigListForContextKeys, args);

    final result = QMapper.remoteConfigListFromJson(rawResult);
    if (result == null) {
      throw QonversionException(
        QErrorCode.internalError.code,
        "Remote config list deserialization failed",
        null,
      );
    }
    return result;
  }

  @override
  Future<void> attachUserToExperiment(String experimentId, String groupId) async {
    final args = {
      Constants.kExperimentId: experimentId,
      Constants.kGroupId: groupId,
    };
    await _invokeMethod(Constants.mAttachUserToExperiment, args);
  }

  @override
  Future<void> detachUserFromExperiment(String experimentId) async {
    final args = {
      Constants.kExperimentId: experimentId,
    };
    await _invokeMethod(Constants.mDetachUserFromExperiment, args);
  }

  Future<void> attachUserToRemoteConfiguration(String remoteConfigurationId) async {
    final args = {
      Constants.kRemoteConfigurationId: remoteConfigurationId,
    };
    await _invokeMethod(Constants.mAttachUserToRemoteConfiguration, args);
  }

  Future<void> detachUserFromRemoteConfiguration(String remoteConfigurationId) async {
    final args = {
      Constants.kRemoteConfigurationId: remoteConfigurationId,
    };
    await _invokeMethod(Constants.mDetachUserFromRemoteConfiguration, args);
  }

  Future<bool> isFallbackFileAccessible() async {
    final rawResult = await _invokeMethod(Constants.mIsFallbackFileAccessible);
    final result = QMapper.mapIsFallbackFileAccessible(rawResult);
    if (result == null) {
      return false;
    }

    return result;
  }

  @override
  Future<void> attribution(Map<dynamic, dynamic> data, QAttributionProvider provider) async {
    final args = {
      Constants.kData: data,
      Constants.kProvider: StringUtils.capitalize(provider.name),
    };

    return await _invokeMethod(Constants.mAddAttributionData, args);
  }

  @override
  Future<void> setUserProperty(QUserPropertyKey property, String value) async {
    if (property == QUserPropertyKey.custom) {
      print("Can not set user property with the key `QUserPropertyKey.custom`. " +
          "To set custom user property, use the `setCustomUserProperty` method.");
      return;
    }

    await _invokeMethod(Constants.mSetDefinedUserProperty, {
      Constants.kProperty: StringUtils.capitalize(property.name),
      Constants.kValue: value,
    });
  }

  @override
  Future<void> setCustomUserProperty(String property, String value) async {
    return await _invokeMethod(Constants.mSetCustomUserProperty, {
      Constants.kProperty: property,
      Constants.kValue: value,
    });
  }

  @override
  Future<QUserProperties> userProperties() async {
    final rawResult = await _invokeMethod(Constants.mUserProperties);

    final result = QMapper.userPropertiesFromJson(rawResult);
    if (result == null) {
      throw QonversionException(
        QErrorCode.internalError.code,
        "User properties deserialization failed",
        null,
      );
    }
    return result;
  }

  @override
  Future<void> collectAdvertisingId() async {
    if (Platform.isIOS) {
      return await _invokeMethod(Constants.mCollectAdvertisingId);
    }
  }

  @override
  Future<void> collectAppleSearchAdsAttribution() async {
    if (Platform.isIOS) {
      return await _invokeMethod(Constants.mCollectAppleSearchAdsAttribution);
    }
  }

  @override
  Future<void> presentCodeRedemptionSheet() async {
    if (Platform.isIOS) {
      return await _invokeMethod(Constants.mPresentCodeRedemptionSheet);
    }
  }

  @override
  Future<Map<String, QEntitlement>?> promoPurchase(String productId) async {
    if (!Platform.isIOS) {
      return null;
    }

    final rawResult = await _invokePurchaseMethod(
        Constants.mPromoPurchase, {Constants.kProductId: productId});
    final result = QMapper.entitlementsFromJson(rawResult);
    return result;
  }

  // Private methods
  Future<void> _storeSdkInfo() async {
    try {
      await _channel.invokeMethod(Constants.mStoreSdkInfo, {
        Constants.kVersion: sdkVersion,
        Constants.kSource: Constants.sdkSource,
      });
    } on PlatformException {
      // Silently ignore errors in SDK info storage
    }
  }

  /// Invokes a method on the platform channel and converts PlatformException to QonversionException
  Future<dynamic> _invokeMethod(String method, [Map<String, dynamic>? arguments]) async {
    try {
      return await _channel.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  /// Invokes a method on the platform channel and converts PlatformException to QPurchaseException
  /// Use this for purchase-related methods
  Future<dynamic> _invokePurchaseMethod(String method, [Map<String, dynamic>? arguments]) async {
    try {
      return await _channel.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  static QPurchaseException _convertPurchaseException(PlatformException error) {
    return QPurchaseException(
        error.code,
        error.message ?? "",
        error.details,
        isUserCancelled: error.code == QErrorCode.purchaseCanceled.code
    );
  }

  static QonversionException _convertPlatformException(PlatformException error) {
    return QonversionException(
        error.code,
        error.message ?? "",
        error.details,
    );
  }
}
