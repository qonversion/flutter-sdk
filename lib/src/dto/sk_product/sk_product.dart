// Copyright 2019 The Chromium Authors. All rights reserved.

import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

import 'sk_product_discount.dart';
import 'subscription_period.dart';

part 'sk_product.g.dart';

/// Dart wrapper around StoreKit's [SKProduct](https://developer.apple.com/documentation/storekit/skproduct?language=objc).
@JsonSerializable()
class SKProduct {
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
  final SKPriceLocale? priceLocale;

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
  final SKProductSubscriptionPeriod? subscriptionPeriod;

  /// The object represents the duration of single subscription period.
  ///
  /// This is only available if you set up the introductory price in the App Store Connect, otherwise it will be null.
  /// Programmer is also responsible to determine if the user is eligible to receive it. See https://developer.apple.com/documentation/storekit/in-app_purchase/offering_introductory_pricing_in_your_app?language=objc
  /// for more details.
  /// The [subscriptionPeriod] of the discount is independent of the product's [subscriptionPeriod],
  /// and their units and duration do not have to be matched.
  @JsonKey(fromJson: QMapper.skProductDiscountFromJson)
  final SKProductDiscount? introductoryPrice;

  @JsonKey(fromJson: QMapper.skProductDiscountFromJson)
  final SKProductDiscount? productDiscount;

  @JsonKey(fromJson: QMapper.skProductDiscountsFromList)
  final List<SKProductDiscount>? discounts;

  /// Creates an [SKProduct] with the given product details.
  const SKProduct({
    required this.productIdentifier,
    required this.localizedTitle,
    required this.localizedDescription,
    required this.priceLocale,
    required this.subscriptionGroupIdentifier,
    required this.price,
    required this.subscriptionPeriod,
    required this.introductoryPrice,
    this.productDiscount,
    this.discounts,
  });

  factory SKProduct.fromJson(Map<String, dynamic> json) =>
      _$SKProductFromJson(json);

  Map<String, dynamic> toJson() => _$SKProductToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SKProduct &&
        other.productIdentifier == productIdentifier &&
        other.localizedTitle == localizedTitle &&
        other.localizedDescription == localizedDescription &&
        other.priceLocale == priceLocale &&
        other.subscriptionGroupIdentifier == subscriptionGroupIdentifier &&
        other.price == price &&
        other.subscriptionPeriod == subscriptionPeriod &&
        other.introductoryPrice == introductoryPrice &&
        other.productDiscount == productDiscount &&
        other.discounts == discounts;
  }

  @override
  int get hashCode => Object.hash(
      this.productIdentifier,
      this.localizedTitle,
      this.localizedDescription,
      this.priceLocale,
      this.subscriptionGroupIdentifier,
      this.price,
      this.subscriptionPeriod,
      this.introductoryPrice,
      this.productDiscount,
      this.discounts);
}

/// Object that indicates the locale of the price
///
/// It is a thin wrapper of [NSLocale](https://developer.apple.com/documentation/foundation/nslocale?language=objc).
@JsonSerializable()
class SKPriceLocale {
  ///The currency symbol for the locale, e.g. $ for US locale.
  final String? currencySymbol;

  ///The currency code for the locale, e.g. USD for US locale.
  final String? currencyCode;

  /// Creates a new price locale for `currencySymbol` and `currencyCode`.
  const SKPriceLocale({
    required this.currencySymbol,
    required this.currencyCode,
  });

  factory SKPriceLocale.fromJson(Map<String, dynamic> json) =>
      _$SKPriceLocaleFromJson(json);

  Map<String, dynamic> toJson() => _$SKPriceLocaleToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SKPriceLocale &&
        other.currencySymbol == currencySymbol &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => Object.hash(this.currencySymbol, this.currencyCode);
}
