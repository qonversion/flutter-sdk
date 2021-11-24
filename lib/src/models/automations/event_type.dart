import 'package:json_annotation/json_annotation.dart';

enum AutomationsEventType {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  trialStarted,
  @JsonValue(2)
  trialConverted,
  @JsonValue(3)
  trialCanceled,
  @JsonValue(4)
  trialBillingRetry,
  @JsonValue(5)
  subscriptionStarted,
  @JsonValue(6)
  subscriptionRenewed,
  @JsonValue(7)
  subscriptionRefunded,
  @JsonValue(8)
  subscriptionCanceled,
  @JsonValue(9)
  subscriptionBillingRetry,
  @JsonValue(10)
  inAppPurchase,
  @JsonValue(11)
  subscriptionUpgraded,
  @JsonValue(12)
  trialStillActive,
  @JsonValue(13)
  trialExpired,
  @JsonValue(14)
  subscriptionExpired,
  @JsonValue(15)
  subscriptionDowngraded,
  @JsonValue(16)
  subscriptionProductChanged,
}
