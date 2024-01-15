import 'package:json_annotation/json_annotation.dart';

enum QTransactionType {
  @JsonValue('Unknown')
  unknown,

  @JsonValue('SubscriptionStarted')
  subscriptionStarted,

  @JsonValue('SubscriptionRenewed')
  subscriptionRenewed,

  @JsonValue('TrialStarted')
  trialStrated,

  @JsonValue('IntroStarted')
  introStarted,

  @JsonValue('IntroRenewed')
  introRenewed,

  @JsonValue('NonConsumablePurchase')
  nonConsumablePurchase,
}
