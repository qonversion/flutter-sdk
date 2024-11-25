import 'package:json_annotation/json_annotation.dart';

part 'sk_payment_discount.g.dart';

/// Dart wrapper around StoreKit's [SKPaymentDiscount](https://developer.apple.com/documentation/storekit/skpaymentdiscount?language=objc).
///
/// It is used as a property in [SKProduct].
@JsonSerializable()
class SKPaymentDiscount {
  /// A string used to uniquely identify a discount offer for a product.
  final String identifier;

  /// A string that identifies the key used to generate the signature.
  final String keyIdentifier;

  /// A universally unique ID (UUID) value that you define.
  final String nonce;

  /// A string representing the properties of a specific promotional offer, cryptographically signed.
  final String signature;

  /// The date and time of the signature's creation in milliseconds, formatted in Unix epoch time.
  final num timestamp;

  /// Creates an [SKPaymentDiscount] with the given discount details.
  SKPaymentDiscount({
    required this.identifier,
    required this.keyIdentifier,
    required this.nonce,
    required this.signature,
    required this.timestamp,
  });

  /// Constructing an instance from a map from the Objective-C layer.
  ///
  /// The `map` parameter must not be null.
  factory SKPaymentDiscount.fromJson(Map<String, dynamic> map) {
    return _$SKPaymentDiscountFromJson(map);
  }

  Map<String, dynamic> toJson() => _$SKPaymentDiscountToJson(this);
}
