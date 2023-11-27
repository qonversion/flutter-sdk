import 'dart:convert';

import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../dto/product_store_details.dart';
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

  static Map<String, QEntitlement> entitlementsFromJson(dynamic json) {
    if (json == null) return <String, QEntitlement>{};

    final entitlementsMap = Map<String, dynamic>.from(json);

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

  static QProductStoreDetails? storeProductDetailsFromJson(dynamic json) {
    if (json == null) return null;

    final map = Map<String, dynamic>.from(json);

    try {
      return QProductStoreDetails.fromJson(map);
    } catch (e) {
      print('Could not parse ProductStoreDetails: $e');
      return null;
    }
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
}
