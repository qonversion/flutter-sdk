import 'package:json_annotation/json_annotation.dart';

enum AutomationsEventType {
  @JsonValue("unknown")
  unknown,
  @JsonValue("trial_started")
  trialStarted,
  @JsonValue("trial_converted")
  trialConverted,
  @JsonValue("trial_canceled")
  trialCanceled,
  @JsonValue("trial_billing_retry_entered")
  trialBillingRetry,
  @JsonValue("subscription_started")
  subscriptionStarted,
  @JsonValue("subscription_renewed")
  subscriptionRenewed,
  @JsonValue("subscription_refunded")
  subscriptionRefunded,
  @JsonValue("subscription_canceled")
  subscriptionCanceled,
  @JsonValue("subscription_billing_retry_entered")
  subscriptionBillingRetry,
  @JsonValue("in_app_purchase")
  inAppPurchase,
  @JsonValue("subscription_upgraded")
  subscriptionUpgraded,
  @JsonValue("trial_still_active")
  trialStillActive,
  @JsonValue("trial_expired")
  trialExpired,
  @JsonValue("subscription_expired")
  subscriptionExpired,
  @JsonValue("subscription_downgraded")
  subscriptionDowngraded,
  @JsonValue("subscription_product_changed")
  subscriptionProductChanged,
}
