// Copyright 2019 The Chromium Authors. All rights reserved.

import 'dart:ui' show hashValues;

import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';

import 'discount.dart';
import 'subscription_period.dart';

part 'sk_product_wrapper.g.dart';

/// Dart wrapper around StoreKit's [SKProduct](https://developer.apple.com/documentation/storekit/skproduct?language=objc).
@JsonSerializable()
class SKProductWrapper {
  /// The unique identifier of the product.
  final String productIdentifier;

  /// The localizedTitle of the product.
  ///
  /// It is localized based on the current locale.
  final String? localizedTitle;

  /// The localized description of the product.
  ///
  /// It is localized based on the current locale.
  final String? localizedDescription;

  /// Includes locale information about the price, e.g. `$` as the currency symbol for US locale.
  @JsonKey(fromJson: QMapper.skPriceLocaleFromJson)
  final SKPriceLocaleWrapper? priceLocale;

  /// The subscription group identifier.
  ///
  /// A subscription group is a collection of subscription products.
  /// Check [SubscriptionGroup](https://developer.apple.com/app-store/subscriptions/) for more details about subscription group.
  final String? subscriptionGroupIdentifier;

  /// The price of the product, in the currency that is defined in [priceLocale].
  final String price;

  /// The object represents the subscription period of the product.
  ///
  /// Can be [null] is the product is not a subscription.
  @JsonKey(fromJson: QMapper.skProductSubscriptionPeriodFromJson)
  final SKProductSubscriptionPeriodWrapper? subscriptionPeriod;

  /// The object represents the duration of single subscription period.
  ///
  /// This is only available if you set up the introductory price in the App Store Connect, otherwise it will be null.
  /// Programmer is also responsible to determine if the user is eligible to receive it. See https://developer.apple.com/documentation/storekit/in-app_purchase/offering_introductory_pricing_in_your_app?language=objc
  /// for more details.
  /// The [subscriptionPeriod] of the discount is independent of the product's [subscriptionPeriod],
  /// and their units and duration do not have to be matched.
  @JsonKey(fromJson: QMapper.skProductDiscountFromJson)
  final SKProductDiscountWrapper? introductoryPrice;

  /// Creates an [SKProductWrapper] with the given product details.
  const SKProductWrapper({
    required this.productIdentifier,
    required this.localizedTitle,
    required this.localizedDescription,
    required this.priceLocale,
    required this.subscriptionGroupIdentifier,
    required this.price,
    required this.subscriptionPeriod,
    required this.introductoryPrice,
  });

  factory SKProductWrapper.fromJson(Map<String, dynamic> json) =>
      _$SKProductWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$SKProductWrapperToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SKProductWrapper &&
        other.productIdentifier == productIdentifier &&
        other.localizedTitle == localizedTitle &&
        other.localizedDescription == localizedDescription &&
        other.priceLocale == priceLocale &&
        other.subscriptionGroupIdentifier == subscriptionGroupIdentifier &&
        other.price == price &&
        other.subscriptionPeriod == subscriptionPeriod &&
        other.introductoryPrice == introductoryPrice;
  }

  @override
  int get hashCode => hashValues(
      this.productIdentifier,
      this.localizedTitle,
      this.localizedDescription,
      this.priceLocale,
      this.subscriptionGroupIdentifier,
      this.price,
      this.subscriptionPeriod,
      this.introductoryPrice);
}

/// Object that indicates the locale of the price
///
/// It is a thin wrapper of [NSLocale](https://developer.apple.com/documentation/foundation/nslocale?language=objc).
@JsonSerializable()
class SKPriceLocaleWrapper {
  ///The currency symbol for the locale, e.g. $ for US locale.
  final String? currencySymbol;

  ///The currency code for the locale, e.g. USD for US locale.
  final String? currencyCode;

  /// Creates a new price locale for `currencySymbol` and `currencyCode`.
  const SKPriceLocaleWrapper({
    required this.currencySymbol,
    required this.currencyCode,
  });

  factory SKPriceLocaleWrapper.fromJson(Map<String, dynamic> json) =>
      _$SKPriceLocaleWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$SKPriceLocaleWrapperToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SKPriceLocaleWrapper &&
        other.currencySymbol == currencySymbol &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => hashValues(this.currencySymbol, this.currencyCode);
}
