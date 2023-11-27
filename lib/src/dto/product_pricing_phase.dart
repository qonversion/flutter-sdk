import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/product_period.dart';
import 'package:qonversion_flutter/src/dto/product_price.dart';

enum QPricingPhaseRecurrenceMode {
  @JsonValue("InfiniteRecurring")
  infiniteRecurring,
  @JsonValue("FiniteRecurring")
  finiteRecurring,
  @JsonValue("NonRecurring")
  nonRecurring
}

enum QPricingPhaseType {
  @JsonValue("Regular")
  regular,
  @JsonValue("FreeTrial")
  freeTrial,
  @JsonValue("SinglePayment")
  singlePayment,
  @JsonValue("DiscountedRecurringPayment")
  discountedRecurringPayment,
  @JsonValue("Unknown")
  unknown
}

@JsonSerializable()
class QProductPricingPhase {
  /// Billing cycle count
  @JsonKey(ignore: true)
  int billingCycleCount;

  /// Billing period details
  @JsonKey(ignore: true)
  QProductPeriod billingPeriod;

  /// Base plan flag
  @JsonKey(ignore: true)
  bool isBasePlan;

  /// Intro flag
  @JsonKey(ignore: true)
  bool isIntro;

  /// Trial flag
  @JsonKey(ignore: true)
  bool isTrial;

  /// Price details
  @JsonKey(ignore: true)
  QProductPrice price;

  /// Recurrence mode
  @JsonKey(ignore: true)
  QPricingPhaseRecurrenceMode recurrenceMode;

  /// Pricing phase type
  @JsonKey(ignore: true)
  QPricingPhaseType type;

  const QProductPricingPhase(
      this.billingCycleCount,
      this.billingPeriod,
      this.isBasePlan,
      this.isIntro,
      this.isTrial,
      this.price,
      this.recurrenceMode,
      this.type);

  factory QProductPricingPhase.fromJson(Map<String, dynamic> json) =>
      _$QProductPricingPhase(json);

  Map<String, dynamic> toJson() => _$QProductPricingPhase(this);
}