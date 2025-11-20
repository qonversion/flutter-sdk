import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/dto/qonversion_exception.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';
import 'package:qonversion_flutter/src/internal/utils/string.dart';

import 'constants.dart';

class QonversionInternal implements Qonversion {
  static const String sdkVersion = "10.0.2";

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
    _channel.invokeMethod(Constants.mInitialize, args).catchError((error) {
      // Silently ignore initialization errors
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
    try {
      return await _channel.invokeMethod(Constants.mSyncHistoricalData);
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> syncStoreKit2Purchases() async {
    if (Platform.isIOS) {
      try {
        return await _channel.invokeMethod(Constants.mSyncStoreKit2Purchases);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
    }
  }

  @override
  Future<QPromotionalOffer?> getPromotionalOffer(QProduct product, SKProductDiscount discount) async {
    if (Platform.isAndroid) {
      return null;
    }

    try {
      final promotionalOfferJson = await _channel.invokeMethod(
        Constants.mGetPromotionalOffer, {
          Constants.kProductId: product.qonversionId,
          Constants.kDiscountId: discount.identifier,
        }
      );

      final result = QMapper.promotionalOfferFromJson(promotionalOfferJson);
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>> purchase(QPurchaseModel purchaseModel) async {
    try {
      final rawResult = await _channel
          .invokeMethod(Constants.mPurchase, {
            Constants.kProductId: purchaseModel.productId,
            Constants.kOfferId: purchaseModel.offerId,
            Constants.kApplyOffer: purchaseModel.applyOffer
          });

      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>> purchaseProduct(QProduct product, {QPurchaseOptions? purchaseOptions}) async {
    try {
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
      final rawResult = await _channel
          .invokeMethod(Constants.mPurchase, {
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
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>?> updatePurchase(QPurchaseUpdateModel purchaseUpdateModel) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final updatePolicy = purchaseUpdateModel.updatePolicy;

      final rawResult = await _channel.invokeMethod(Constants.mUpdatePurchase, {
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
    } on PlatformException catch (e) {
      throw _convertPurchaseException(e);
    }
  }

  @override
  Future<Map<String, QProduct>> products() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mProducts);

      final result = QMapper.productsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<QOfferings> offerings() async {
    try {
      final offeringsString = await _channel.invokeMethod<String>(Constants.mOfferings);

      final result = QMapper.offeringsFromJson(offeringsString);
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<Map<String, QEligibility>> checkTrialIntroEligibility(List<String> ids) async {
    try {
      final eligibilitiesString = await _channel.invokeMethod<String>(
          Constants.mCheckTrialIntroEligibility, {"ids": ids});

      final result = QMapper.eligibilityFromJson(eligibilitiesString);
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>> checkEntitlements() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mCheckEntitlements);

      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<Map<String, QEntitlement>> restore() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mRestore);

      final result = QMapper.entitlementsFromJson(rawResult);
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> syncPurchases() async {
    if (Platform.isAndroid) {
      try {
        return await _channel.invokeMethod(Constants.mSyncPurchases);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
    }
  }

  @override
  Future<QUser> identify(String userId) async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mIdentify, {Constants.kUserId: userId});

      final result = QMapper.userFromJson(rawResult);
      if (result == null) {
        throw new Exception("User deserialization failed");
      }
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      return await _channel.invokeMethod(Constants.mLogout);
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<QUser> userInfo() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mUserInfo);

      final result = QMapper.userFromJson(rawResult);
      if (result == null) {
        throw new Exception("User deserialization failed");
      }
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<QRemoteConfig> remoteConfig({String? contextKey}) async {
    try {
      final args = {
        Constants.kContextKey: contextKey,
      };
      final rawResult = await _channel.invokeMethod(Constants.mRemoteConfig, args);

      final result = QMapper.remoteConfigFromJson(rawResult);
      if (result == null) {
        throw new Exception("Remote config deserialization failed");
      }
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<QRemoteConfigList> remoteConfigList() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mRemoteConfigList);

      final result = QMapper.remoteConfigListFromJson(rawResult);
      if (result == null) {
        throw new Exception("Remote config list deserialization failed");
      }
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<QRemoteConfigList> remoteConfigListForContextKeys(
      List<String> contextKeys,
      bool includeEmptyContextKey
  ) async {
    try {
      final args = {
        Constants.kContextKeys: contextKeys,
        Constants.kIncludeEmptyContextKey: includeEmptyContextKey,
      };
      final rawResult = await _channel.invokeMethod(Constants.mRemoteConfigListForContextKeys, args);

      final result = QMapper.remoteConfigListFromJson(rawResult);
      if (result == null) {
        throw new Exception("Remote config list deserialization failed");
      }
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> attachUserToExperiment(String experimentId, String groupId) async {
    try {
      final args = {
        Constants.kExperimentId: experimentId,
        Constants.kGroupId: groupId,
      };
      await _channel.invokeMethod(Constants.mAttachUserToExperiment, args);
      return;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> detachUserFromExperiment(String experimentId) async {
    try {
      final args = {
        Constants.kExperimentId: experimentId,
      };
      await _channel.invokeMethod(Constants.mDetachUserFromExperiment, args);
      return;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  Future<void> attachUserToRemoteConfiguration(String remoteConfigurationId) async {
    try {
      final args = {
        Constants.kRemoteConfigurationId: remoteConfigurationId,
      };
      await _channel.invokeMethod(Constants.mAttachUserToRemoteConfiguration, args);
      return;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  Future<void> detachUserFromRemoteConfiguration(String remoteConfigurationId) async {
    try {
      final args = {
        Constants.kRemoteConfigurationId: remoteConfigurationId,
      };
      await _channel.invokeMethod(Constants.mDetachUserFromRemoteConfiguration, args);
      return;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  Future<bool> isFallbackFileAccessible() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mIsFallbackFileAccessible);
      final result = QMapper.mapIsFallbackFileAccessible(rawResult);
      if (result == null) {
        return false;
      }

      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> attribution(Map<dynamic, dynamic> data, QAttributionProvider provider) async {
    try {
      final args = {
        Constants.kData: data,
        Constants.kProvider: StringUtils.capitalize(provider.name),
      };

      return await _channel.invokeMethod(Constants.mAddAttributionData, args);
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> setUserProperty(QUserPropertyKey property, String value) async {
    if (property == QUserPropertyKey.custom) {
      print("Can not set user property with the key `QUserPropertyKey.custom`. " +
          "To set custom user property, use the `setCustomUserProperty` method.");
      return;
    }

    try {
      await _channel.invokeMethod(Constants.mSetDefinedUserProperty, {
        Constants.kProperty: StringUtils.capitalize(property.name),
        Constants.kValue: value,
      });
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> setCustomUserProperty(String property, String value) async {
    try {
      return await _channel.invokeMethod(Constants.mSetCustomUserProperty, {
        Constants.kProperty: property,
        Constants.kValue: value,
      });
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<QUserProperties> userProperties() async {
    try {
      final rawResult = await _channel.invokeMethod(Constants.mUserProperties);

      final result = QMapper.userPropertiesFromJson(rawResult);
      if (result == null) {
        throw new Exception("User properties deserialization failed");
      }
      return result;
    } on PlatformException catch (e) {
      throw _convertPlatformException(e);
    }
  }

  @override
  Future<void> collectAdvertisingId() async {
    if (Platform.isIOS) {
      try {
        return await _channel.invokeMethod(Constants.mCollectAdvertisingId);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
    }
  }

  @override
  Future<void> collectAppleSearchAdsAttribution() async {
    if (Platform.isIOS) {
      try {
        return await _channel.invokeMethod(Constants.mCollectAppleSearchAdsAttribution);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
    }
  }

  @override
  Future<void> presentCodeRedemptionSheet() async {
    if (Platform.isIOS) {
      try {
        return await _channel.invokeMethod(Constants.mPresentCodeRedemptionSheet);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
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
  Future<void> _storeSdkInfo() async {
    try {
      await _channel.invokeMethod(Constants.mStoreSdkInfo, {
        Constants.kVersion: sdkVersion,
        Constants.kSource: Constants.sdkSource,
      });
    } on PlatformException catch (e) {
      // Silently ignore errors in SDK info storage
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
