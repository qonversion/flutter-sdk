import 'package:json_annotation/json_annotation.dart';

enum QEntitlementRenewState {
  /// For in-app purchases.
  @JsonValue('non_renewable')
  nonRenewable,

  /// For in-app purchases.
  @JsonValue('unknown')
  unknown,

  /// Subscription is active and will renew
  @JsonValue('will_renew')
  willRenew,

  /// The user canceled the subscription, but the subscription may be active.
  /// Check isActive to be sure that the subscription has not expired yet.
  @JsonValue('canceled')
  canceled,

  /// There was some billing issue.
  /// Prompt the user to update the payment method.
  @JsonValue('billing_issue')
  billingIssue,
}
