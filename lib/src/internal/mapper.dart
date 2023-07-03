import 'dart:convert';

import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../dto/qonversion_error.dart';
import '../dto/eligibility.dart';
import '../dto/offerings.dart';
import '../dto/entitlement.dart';
import '../dto/product.dart';
import '../dto/user.dart';
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
