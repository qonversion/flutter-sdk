// Copyright 2019 The Chromium Authors. All rights reserved.

import 'dart:ui' show hashValues;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';

import 'sk_product/discount.dart';
import 'sk_product/discount_payment_mode.dart';
import 'sk_product/subscription_period.dart';
import 'sk_product/subscription_period_unit.dart';

part 'sk_product_wrapper.g.dart';

/// Dart wrapper around StoreKit's [SKProduct](https://developer.apple.com/documentation/storekit/skproduct?language=objc).
///
/// A list of [SKProductWrapper] is returned in the [SKRequestMaker.startProductRequest] method, and
/// should be stored for use when making a payment.
@JsonSerializable(nullable: true)
class SKProductWrapper {
  /// The unique identifier of the product.
  final String productIdentifier;

  /// The localizedTitle of the product.
  ///
  /// It is localized based on the current locale.
  final String localizedTitle;

  /// The localized description of the product.
  ///
  /// It is localized based on the current locale.
  final String localizedDescription;

  /// Includes locale information about the price, e.g. `$` as the currency symbol for US locale.
  @JsonKey(fromJson: QMapper.skPriceLocaleFromJson)
  final SKPriceLocaleWrapper priceLocale;

  /// The subscription group identifier.
  ///
  /// A subscription group is a collection of subscription products.
  /// Check [SubscriptionGroup](https://developer.apple.com/app-store/subscriptions/) for more details about subscription group.
  final String subscriptionGroupIdentifier;

  /// The price of the product, in the currency that is defined in [priceLocale].
  final String price;

  /// The object represents the subscription period of the product.
  ///
  /// Can be [null] is the product is not a subscription.
  @JsonKey(fromJson: QMapper.skProductSubscriptionPeriodFromJson)
  final SKProductSubscriptionPeriodWrapper subscriptionPeriod;

  /// The object represents the duration of single subscription period.
  ///
  /// This is only available if you set up the introductory price in the App Store Connect, otherwise it will be null.
  /// Programmer is also responsible to determine if the user is eligible to receive it. See https://developer.apple.com/documentation/storekit/in-app_purchase/offering_introductory_pricing_in_your_app?language=objc
  /// for more details.
  /// The [subscriptionPeriod] of the discount is independent of the product's [subscriptionPeriod],
  /// and their units and duration do not have to be matched.
  @JsonKey(fromJson: QMapper.skProductDiscountFromJson)
  final SKProductDiscountWrapper introductoryPrice;

  /// Creates an [SKProductWrapper] with the given product details.
  SKProductWrapper({
    @required this.productIdentifier,
    @required this.localizedTitle,
    @required this.localizedDescription,
    @required this.priceLocale,
    @required this.subscriptionGroupIdentifier,
    @required this.price,
    @required this.subscriptionPeriod,
    @required this.introductoryPrice,
  });

  /// Constructing an instance from a map from the Objective-C layer.
  ///
  /// This method should only be used with `map` values returned by [SkProductResponseWrapper.fromJson].
  /// The `map` parameter must not be null.
  factory SKProductWrapper.fromJson(Map<String, dynamic> map) {
    assert(map != null, 'Map must not be null.');
    return _$SKProductWrapperFromJson(map);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKProductWrapper typedOther = other;
    return typedOther.productIdentifier == productIdentifier &&
        typedOther.localizedTitle == localizedTitle &&
        typedOther.localizedDescription == localizedDescription &&
        typedOther.priceLocale == priceLocale &&
        typedOther.subscriptionGroupIdentifier == subscriptionGroupIdentifier &&
        typedOther.price == price &&
        typedOther.subscriptionPeriod == subscriptionPeriod &&
        typedOther.introductoryPrice == introductoryPrice;
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
// TODO(cyanglaz): NSLocale is a complex object, want to see the actual need of getting this expanded.
//                 Matching android to only get the currencySymbol for now.
//                 https://github.com/flutter/flutter/issues/26610
@JsonSerializable()
class SKPriceLocaleWrapper {
  ///The currency symbol for the locale, e.g. $ for US locale.
  final String currencySymbol;

  ///The currency code for the locale, e.g. USD for US locale.
  final String currencyCode;

  /// Creates a new price locale for `currencySymbol` and `currencyCode`.
  SKPriceLocaleWrapper({
    @required this.currencySymbol,
    @required this.currencyCode,
  });

  /// Constructing an instance from a map from the Objective-C layer.
  ///
  /// This method should only be used with `map` values returned by [SKProductWrapper.fromJson] and [SKProductDiscountWrapper.fromJson].
  /// The `map` parameter must not be null.
  factory SKPriceLocaleWrapper.fromJson(Map map) {
    assert(map != null, 'Map must not be null.');
    return _$SKPriceLocaleWrapperFromJson(map);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKPriceLocaleWrapper typedOther = other;
    return typedOther.currencySymbol == currencySymbol &&
        typedOther.currencyCode == currencyCode;
  }

  @override
  int get hashCode => hashValues(this.currencySymbol, this.currencyCode);
}
