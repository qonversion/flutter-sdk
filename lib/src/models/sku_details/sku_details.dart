// Copyright 2019 The Chromium Authors. All rights reserved.

import 'dart:ui' show hashValues;

import 'package:json_annotation/json_annotation.dart';

part 'sku_details.g.dart';

/// Enum representing potential [SkuDetailsWrapper.type]s.
///
/// Wraps
/// [`BillingClient.SkuType`](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.SkuType)
/// See the linked documentation for an explanation of the different constants.
enum SkuType {
// WARNING: Changes to this class need to be reflected in our generated code.
// Run `flutter packages pub run build_runner watch` to rebuild and watch for
// further changes.

  /// A one time product. Acquired in a single transaction.
  @JsonValue('inapp')
  inapp,

  /// A product requiring a recurring charge over time.
  @JsonValue('subs')
  subs,
}

/// Dart wrapper around [`com.android.billingclient.api.SkuDetails`](https://developer.android.com/reference/com/android/billingclient/api/SkuDetails).
///
/// Contains the details of an available product in Google Play Billing.
@JsonSerializable()
class SkuDetailsWrapper {
  /// Textual description of the product.
  final String description;

  /// Trial period in ISO 8601 format.
  final String freeTrialPeriod;

  /// Introductory price, only applies to [SkuType.subs]. Formatted ("$0.99").
  final String introductoryPrice;

  /// Introductory price in micro-units 990000
  final int introductoryPriceAmountMicros;

  /// The number of billing perios that [introductoryPrice] is valid for ("2").
  final int introductoryPriceCycles;

  /// The billing period of [introductoryPrice], in ISO 8601 format.
  final String introductoryPricePeriod;

  /// Formatted with currency symbol ("$0.99").
  final String price;

  /// [price] in micro-units (990000).
  final int priceAmountMicros;

  /// [price] ISO 4217 currency code.
  final String priceCurrencyCode;

  /// The product ID in Google Play Console.
  final String sku;

  /// Applies to [SkuType.subs], formatted in ISO 8601.
  final String subscriptionPeriod;

  /// The product's title.
  final String title;

  /// The [SkuType] of the product.
  final SkuType type;

  /// The original price that the user purchased this product for.
  final String originalPrice;

  /// [originalPrice] in micro-units (990000).
  final int originalPriceAmountMicros;

  /// SKU details in JSON format.
  final String originalJson;

  /// Creates a [SkuDetailsWrapper] with the given purchase details.
  SkuDetailsWrapper(
      {required this.description,
      required this.freeTrialPeriod,
      required this.introductoryPrice,
      required this.introductoryPriceAmountMicros,
      required this.introductoryPriceCycles,
      required this.introductoryPricePeriod,
      required this.price,
      required this.priceAmountMicros,
      required this.priceCurrencyCode,
      required this.sku,
      required this.subscriptionPeriod,
      required this.title,
      required this.type,
      required this.originalPrice,
      required this.originalPriceAmountMicros,
      required this.originalJson});

  /// Constructs an instance of this from a key value map of data.
  ///
  /// The map needs to have named string keys with values matching the names and
  /// types of all of the members on this class.
  factory SkuDetailsWrapper.fromJson(Map<String, dynamic> map) =>
      _$SkuDetailsWrapperFromJson(map);

  Map<String, dynamic> toJson() => _$SkuDetailsWrapperToJson(this);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SkuDetailsWrapper typedOther = other;
    return typedOther is SkuDetailsWrapper &&
        typedOther.description == description &&
        typedOther.freeTrialPeriod == freeTrialPeriod &&
        typedOther.introductoryPrice == introductoryPrice &&
        typedOther.introductoryPriceAmountMicros ==
            introductoryPriceAmountMicros &&
        typedOther.introductoryPriceCycles == introductoryPriceCycles &&
        typedOther.introductoryPricePeriod == introductoryPricePeriod &&
        typedOther.price == price &&
        typedOther.priceAmountMicros == priceAmountMicros &&
        typedOther.sku == sku &&
        typedOther.subscriptionPeriod == subscriptionPeriod &&
        typedOther.title == title &&
        typedOther.type == type &&
        typedOther.originalPrice == originalPrice &&
        typedOther.originalPriceAmountMicros == originalPriceAmountMicros &&
        typedOther.originalJson == originalJson;
  }

  @override
  int get hashCode {
    return hashValues(
        description.hashCode,
        freeTrialPeriod.hashCode,
        introductoryPrice.hashCode,
        introductoryPriceAmountMicros.hashCode,
        introductoryPriceCycles.hashCode,
        introductoryPricePeriod.hashCode,
        price.hashCode,
        priceAmountMicros.hashCode,
        sku.hashCode,
        subscriptionPeriod.hashCode,
        title.hashCode,
        type.hashCode,
        originalPrice,
        originalPriceAmountMicros,
        originalJson.hashCode);
  }
}
