import 'dart:convert';

import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/dto/transaction.dart';

import '../dto/entitlement_grant_type.dart';
import '../dto/sk_product/discount.dart';
import '../dto/sk_product/sk_product_wrapper.dart';
import '../dto/sk_product/subscription_period.dart';
import '../dto/sku_details/sku_details.dart';

class QMapper {
  static Map<String, QProduct> productsFromJson(dynamic json) {
    if (json == null) return <String, QProduct>{};

    final productsMap = Map<String, dynamic>.from(json);

    return productsMap.map((key, value) {
      final productMap = Map<String, dynamic>.from(value);
      return MapEntry(key, QProduct.fromJson(productMap));
    });
  }

  static Map<String, QEntitlement> entitlementsFromJson(String? jsonString) {
    if (jsonString == null) return <String, QEntitlement>{};

    final entitlementsMap = Map<String, dynamic>.from(jsonDecode(jsonString));

    return entitlementsMap.map((key, value) {
      final entitlementMap = Map<String, dynamic>.from(value);
      return MapEntry(key, QEntitlement.fromJson(entitlementMap));
    });
  }

  static QOfferings offeringsFromJson(String? jsonString) {
    if (jsonString == null) return QOfferings(null, <QOffering>[]);

    final offeringJson = Map<String, dynamic>.from(jsonDecode(jsonString));

    return QOfferings.fromJson(offeringJson);
  }

  static QUser? userFromJson(dynamic jsonString) {
    if (jsonString == null) return null;

    final userMap = Map<String, dynamic>.from(jsonString);

    return QUser.fromJson(userMap);
  }

  static QRemoteConfig? remoteConfigFromJson(String? jsonString) {
    if (jsonString == null) return null;

    final remoteConfigMap = Map<String, dynamic>.from(jsonDecode(jsonString));

    return QRemoteConfig.fromJson(remoteConfigMap);
  }

  static Map<String, QEligibility> eligibilityFromJson(String? jsonString) {
    if (jsonString == null) return <String, QEligibility>{};

    final eligibilityJson = Map<String, dynamic>.from(jsonDecode(jsonString));

    return eligibilityJson
        .map((key, value) => MapEntry(key, QEligibility.fromJson(value)));
  }

  static QUserPropertyKey userPropertyKeyFromString(String sourceKey) {
    switch (sourceKey) {
      case '_q_email':
        return QUserPropertyKey.email;
      case '_q_name':
        return QUserPropertyKey.name;
      case '_q_kochava_device_id':
        return QUserPropertyKey.kochavaDeviceId;
      case '_q_appsflyer_user_id':
        return QUserPropertyKey.appsFlyerUserId;
      case '_q_adjust_adid':
        return QUserPropertyKey.adjustAdId;
      case '_q_custom_user_id':
        return QUserPropertyKey.customUserId;
      case '_q_fb_attribution':
        return QUserPropertyKey.facebookAttribution;
      case '_q_firebase_instance_id':
        return QUserPropertyKey.firebaseAppInstanceId;
      case '_q_app_set_id':
        return QUserPropertyKey.appSetId;
      case '_q_advertising_id':
        return QUserPropertyKey.advertisingId;
    }

    return QUserPropertyKey.custom;
  }

  static QUserProperties? userPropertiesFromJson(String? jsonString) {
    if (jsonString == null) return null;

    final propertiesMap = Map<String, dynamic>.from(jsonDecode(jsonString));

    return QUserProperties.fromJson(propertiesMap);
  }

  static SKProductWrapper? skProductFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    try {
      return SKProductWrapper.fromJson(map);
    } catch (e) {
      print('Could not parse SKProduct: $e');
      return null;
    }
  }

  static SKPriceLocaleWrapper? skPriceLocaleFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    return SKPriceLocaleWrapper.fromJson(map);
  }

  static SKProductSubscriptionPeriodWrapper?
      skProductSubscriptionPeriodFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    return SKProductSubscriptionPeriodWrapper.fromJson(map);
  }

  static SKProductDiscountWrapper? skProductDiscountFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    return SKProductDiscountWrapper.fromJson(map);
  }

  static SkuDetailsWrapper? skuDetailsFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    try {
      return SkuDetailsWrapper.fromJson(map);
    } catch (e) {
      print('Could not parse SkuDetails: $e');
      return null;
    }
  }

  static QEntitlementGrantType grantTypeFromNullableValue(String? value) {
    if (value == null) return QEntitlementGrantType.purchase;

    final type = _QEntitlementGrantTypeEnumMap[value];
    if (type == null) return QEntitlementGrantType.purchase;

    return type;
  }

  static List<QTransaction> transactionsFromNullableValue(List<dynamic>? json) {
    if (json == null) return [];
    return json.map((e) => QTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static DateTime? dateTimeFromNullableSecondsTimestamp(num? timestamp) {
    if (timestamp == null) return null;

    return dateTimeFromSecondsTimestamp(timestamp);
  }

  static DateTime dateTimeFromSecondsTimestamp(num timestamp) {
    final intAbsTimestamp = timestamp.toInt().abs();
    return DateTime.fromMillisecondsSinceEpoch(intAbsTimestamp);
  }

  static QError? qonversionErrorFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    try {
      return QError.fromJson(map);
    } catch (e) {
      print('Could not parse QError: $e');
      return null;
    }
  }

  static const _QEntitlementGrantTypeEnumMap = {
    'Purchase': QEntitlementGrantType.purchase,
    'FamilySharing': QEntitlementGrantType.familySharing,
    'OfferCode': QEntitlementGrantType.offerCode,
    'Manual': QEntitlementGrantType.manual,
  };
}
