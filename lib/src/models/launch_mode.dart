import 'package:json_annotation/json_annotation.dart';

enum QLaunchMode {
  @JsonValue("Analytics")
  analytics,

  @JsonValue("SubscriptionManagement")
  subscriptionManagement,
}
