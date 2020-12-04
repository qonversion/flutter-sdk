import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'subscription_period_unit.dart';

part 'subscription_period.g.dart';

/// Dart wrapper around StoreKit's [SKProductSubscriptionPeriod](https://developer.apple.com/documentation/storekit/skproductsubscriptionperiod?language=objc).
///
/// A period is defined by a [numberOfUnits] and a [unit], e.g for a 3 months period [numberOfUnits] is 3 and [unit] is a month.
/// It is used as a property in [SKProductDiscountWrapper] and [SKProductWrapper].
@JsonSerializable(nullable: true)
class SKProductSubscriptionPeriodWrapper {
  /// Creates an [SKProductSubscriptionPeriodWrapper] for a `numberOfUnits`x`unit` period.

  /// The number of [unit] units in this period.
  ///
  /// Must be greater than 0.
  final int numberOfUnits;

  /// The time unit used to specify the length of this period.
  final SKSubscriptionPeriodUnit unit;

  SKProductSubscriptionPeriodWrapper({
    @required this.numberOfUnits,
    @required this.unit,
  });

  /// Constructing an instance from a map from the Objective-C layer.
  ///
  /// This method should only be used with `map` values returned by [SKProductDiscountWrapper.fromJson] or [SKProductWrapper.fromJson].
  /// The `map` parameter must not be null.
  factory SKProductSubscriptionPeriodWrapper.fromJson(Map map) {
    assert(map != null, 'Map must not be null.');
    return _$SKProductSubscriptionPeriodWrapperFromJson(map);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKProductSubscriptionPeriodWrapper typedOther = other;
    return typedOther.numberOfUnits == numberOfUnits && typedOther.unit == unit;
  }

  @override
  int get hashCode => hashValues(this.numberOfUnits, this.unit);
}
