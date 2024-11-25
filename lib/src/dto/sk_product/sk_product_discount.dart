import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

import 'discount_payment_mode.dart';
import 'sk_product.dart';
import 'subscription_period.dart';

part 'sk_product_discount.g.dart';

/// Dart wrapper around StoreKit's [SKProductDiscount](https://developer.apple.com/documentation/storekit/skproductdiscount?language=objc).
///
/// It is used as a property in [SKProduct].
@JsonSerializable()
class SKProductDiscount {
  final String? identifier;

  /// The discounted price, in the currency that is defined in [priceLocale].
  final String price;

  /// Includes locale information about the price, e.g. `$` as the currency symbol for US locale.
  @JsonKey(fromJson: QMapper.skPriceLocaleFromJson)
  final SKPriceLocale? priceLocale;

  /// The object represent the discount period length.
  ///
  /// The value must be >= 0.
  final int numberOfPeriods;

  /// The object indicates how the discount price is charged.
  final SKProductDiscountPaymentMode paymentMode;

  /// The object represents the duration of single subscription period for the discount.
  ///
  /// The [subscriptionPeriod] of the discount is independent of the product's [subscriptionPeriod],
  /// and their units and duration do not have to be matched.
  @JsonKey(fromJson: QMapper.skProductSubscriptionPeriodFromJson)
  final SKProductSubscriptionPeriod? subscriptionPeriod;

  /// Creates an [SKProductDiscount] with the given discount details.
  SKProductDiscount({
    required this.identifier,
    required this.price,
    required this.priceLocale,
    required this.numberOfPeriods,
    required this.paymentMode,
    required this.subscriptionPeriod,
  });

  /// Constructing an instance from a map from the Objective-C layer.
  ///
  /// This method should only be used with `map` values returned by [SKProduct.fromJson].
  /// The `map` parameter must not be null.
  factory SKProductDiscount.fromJson(Map<String, dynamic> map) {
    return _$SKProductDiscountFromJson(map);
  }

  Map<String, dynamic> toJson() => _$SKProductDiscountToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SKProductDiscount &&
        other.identifier == identifier &&
        other.price == price &&
        other.priceLocale == priceLocale &&
        other.numberOfPeriods == numberOfPeriods &&
        other.paymentMode == paymentMode &&
        other.subscriptionPeriod == subscriptionPeriod;
  }

  @override
  int get hashCode => Object.hash(this.identifier, this.price, this.priceLocale,
      this.numberOfPeriods, this.paymentMode, this.subscriptionPeriod);
}
