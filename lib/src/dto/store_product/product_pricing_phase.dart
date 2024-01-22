import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';
import '../subscription_period.dart';
import 'product_price.dart';

part 'product_pricing_phase.g.dart';

/// Recurrence mode of the pricing phase.
enum QPricingPhaseRecurrenceMode {
  /// The billing plan payment recurs for infinite billing periods unless canceled.
  @JsonValue("InfiniteRecurring")
  infiniteRecurring,

  /// The billing plan payment recurs for a fixed number of billing periods
  /// set in [QProductPricingPhase.billingCycleCount].
  @JsonValue("FiniteRecurring")
  finiteRecurring,

  /// The billing plan payment is a one-time charge that does not repeat.
  @JsonValue("NonRecurring")
  nonRecurring,

  /// Unknown recurrence mode.
  @JsonValue("Unknown")
  unknown
}

/// Type of the pricing phase.
enum QPricingPhaseType {
  /// Regular subscription without any discounts like trial or intro offers.
  @JsonValue("Regular")
  regular,

  /// A free phase.
  @JsonValue("FreeTrial")
  freeTrial,

  /// A phase with a discounted payment for a single period.
  @JsonValue("DiscountedSinglePayment")
  discountedSinglePayment,

  /// A phase with a discounted payment for several periods, described in [QProductPricingPhase.billingCycleCount].
  @JsonValue("DiscountedRecurringPayment")
  discountedRecurringPayment,

  /// Unknown pricing phase type
  @JsonValue("Unknown")
  unknown
}

/// This class represents a pricing phase, describing how a user pays at a point in time.
@JsonSerializable()
class QProductPricingPhase {
  /// Price for the current phase.
  @JsonKey(name: 'price', fromJson: QMapper.requiredProductPriceFromJson)
  final QProductPrice price;

  /// The billing period for which the given price applies.
  @JsonKey(name: 'billingPeriod', fromJson: QMapper.requiredSubscriptionPeriodFromJson)
  final QSubscriptionPeriod billingPeriod;

  /// Number of cycles for which the billing period is applied.
  @JsonKey(name: 'billingCycleCount')
  final int billingCycleCount;

  /// Recurrence mode for the pricing phase.
  @JsonKey(name: 'recurrenceMode', unknownEnumValue: QPricingPhaseRecurrenceMode.unknown)
  final QPricingPhaseRecurrenceMode recurrenceMode;

  /// Type of the pricing phase.
  @JsonKey(name: 'type', unknownEnumValue: QPricingPhaseType.unknown)
  final QPricingPhaseType type;

  /// True, if the current phase is a trial period. False otherwise.
  @JsonKey(name: 'isTrial')
  final bool isTrial;

  /// True, if the current phase is an intro period. False otherwise.
  /// The intro phase is one of single or recurrent discounted payments.
  @JsonKey(name: 'isIntro')
  final bool isIntro;

  /// True, if the current phase represents the base plan. False otherwise.
  @JsonKey(name: 'isBasePlan')
  final bool isBasePlan;

  const QProductPricingPhase(
      this.price,
      this.billingPeriod,
      this.billingCycleCount,
      this.recurrenceMode,
      this.type,
      this.isTrial,
      this.isIntro,
      this.isBasePlan,
  );

  factory QProductPricingPhase.fromJson(Map<String, dynamic> json) =>
      _$QProductPricingPhaseFromJson(json);

  Map<String, dynamic> toJson() => _$QProductPricingPhaseToJson(this);
}