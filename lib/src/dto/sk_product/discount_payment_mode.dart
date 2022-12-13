import 'package:json_annotation/json_annotation.dart';

/// Dart wrapper around StoreKit's [SKProductDiscountPaymentMode](https://developer.apple.com/documentation/storekit/skproductdiscountpaymentmode?language=objc).
///
/// This is used as a property in the [SKProductDiscountWrapper].
// The values of the enum options are matching the [SKProductDiscountPaymentMode]'s values. Should there be an update or addition
// in the [SKProductDiscountPaymentMode], this need to be updated to match.
enum SKProductDiscountPaymentMode {
  /// Allows user to pay the discounted price at each payment period.
  @JsonValue(0)
  payAsYouGo,

  /// Allows user to pay the discounted price upfront and receive the product for the rest of time that was paid for.
  @JsonValue(1)
  payUpFront,

  /// User pays nothing during the discounted period.
  @JsonValue(2)
  freeTrial,
}
