import 'package:json_annotation/json_annotation.dart';

enum QProductRenewState {
  /// For in-app purchases.
  @JsonValue(-1)
  nonRenewable,

  /// For in-app purchases.
  @JsonValue(0)
  unknown,

  /// Subscription is active and will renew
  @JsonValue(1)
  willRenew,

  /// The user canceled the subscription, but the subscription may be active.
  /// Check isActive to be sure that the subscription has not expired yet.
  @JsonValue(2)
  canceled,

  /// There was some billing issue.
  /// Prompt the user to update the payment method.
  @JsonValue(3)
  billingIssue,
}
