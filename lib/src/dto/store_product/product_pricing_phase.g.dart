// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_pricing_phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductPricingPhase _$QProductPricingPhaseFromJson(
        Map<String, dynamic> json) =>
    QProductPricingPhase(
      QMapper.requiredProductPriceFromJson(json['price']),
      QMapper.requiredSubscriptionPeriodFromJson(json['billingPeriod']),
      (json['billingCycleCount'] as num).toInt(),
      $enumDecode(_$QPricingPhaseRecurrenceModeEnumMap, json['recurrenceMode'],
          unknownValue: QPricingPhaseRecurrenceMode.unknown),
      $enumDecode(_$QPricingPhaseTypeEnumMap, json['type'],
          unknownValue: QPricingPhaseType.unknown),
      json['isTrial'] as bool,
      json['isIntro'] as bool,
      json['isBasePlan'] as bool,
    );

Map<String, dynamic> _$QProductPricingPhaseToJson(
        QProductPricingPhase instance) =>
    <String, dynamic>{
      'price': instance.price,
      'billingPeriod': instance.billingPeriod,
      'billingCycleCount': instance.billingCycleCount,
      'recurrenceMode':
          _$QPricingPhaseRecurrenceModeEnumMap[instance.recurrenceMode]!,
      'type': _$QPricingPhaseTypeEnumMap[instance.type]!,
      'isTrial': instance.isTrial,
      'isIntro': instance.isIntro,
      'isBasePlan': instance.isBasePlan,
    };

const _$QPricingPhaseRecurrenceModeEnumMap = {
  QPricingPhaseRecurrenceMode.infiniteRecurring: 'InfiniteRecurring',
  QPricingPhaseRecurrenceMode.finiteRecurring: 'FiniteRecurring',
  QPricingPhaseRecurrenceMode.nonRecurring: 'NonRecurring',
  QPricingPhaseRecurrenceMode.unknown: 'Unknown',
};

const _$QPricingPhaseTypeEnumMap = {
  QPricingPhaseType.regular: 'Regular',
  QPricingPhaseType.freeTrial: 'FreeTrial',
  QPricingPhaseType.discountedSinglePayment: 'DiscountedSinglePayment',
  QPricingPhaseType.discountedRecurringPayment: 'DiscountedRecurringPayment',
  QPricingPhaseType.unknown: 'Unknown',
};
