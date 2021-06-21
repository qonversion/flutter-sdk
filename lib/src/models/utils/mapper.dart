import 'dart:convert';

import '../eligibility.dart';
import '../offerings.dart';
import '../permission.dart';
import '../product.dart';
import '../sk_product/discount.dart';
import '../sk_product/sk_product_wrapper.dart';
import '../sk_product/subscription_period.dart';
import '../sku_details/sku_details.dart';

class QMapper {
  static Map<String, QProduct> productsFromJson(dynamic json) {
    if (json == null) return <String, QProduct>{};

    final productsMap = Map<String, dynamic>.from(json);

    return productsMap.map((key, value) {
      final productMap = Map<String, dynamic>.from(value);
      return MapEntry(key, QProduct.fromJson(productMap));
    });
  }

  static Map<String, QPermission> permissionsFromJson(dynamic json) {
    if (json == null) return <String, QPermission>{};

    final permissionsMap = Map<String, dynamic>.from(json);

    return permissionsMap.map((key, value) {
      final permissionMap = Map<String, dynamic>.from(value);
      return MapEntry(key, QPermission.fromJson(permissionMap));
    });
  }

  static QOfferings offeringsFromJson(String? jsonString) {
    if (jsonString == null) return QOfferings(null, <QOffering>[]);

    final offeringJson = Map<String, dynamic>.from(jsonDecode(jsonString));

    return QOfferings.fromJson(offeringJson);
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

  static DateTime? dateTimeFromSecondsTimestamp(num? timestamp) {
    if (timestamp == null) return null;

    final intAbsTimestamp = timestamp.toInt().abs();
    return DateTime.fromMillisecondsSinceEpoch(intAbsTimestamp);
  }
}
