import 'package:json_annotation/json_annotation.dart';

/// Dart wrapper around StoreKit's [SKProductPeriodUnit](https://developer.apple.com/documentation/storekit/skproductperiodunit?language=objc).
///
/// Used as a property in the [SKProductSubscriptionPeriodWrapper]. Minimum is a day and maximum is a year.
// The values of the enum options are matching the [SKProductPeriodUnit]'s values. Should there be an update or addition
// in the [SKProductPeriodUnit], this need to be updated to match.
enum SKSubscriptionPeriodUnit {
  /// An interval lasting one day.
  @JsonValue(0)
  day,

  /// An interval lasting one week.
  @JsonValue(1)
  week,

  /// An interval lasting one month.
  @JsonValue(2)
  month,

  /// An interval lasting one year.
  @JsonValue(3)
  year,
}
