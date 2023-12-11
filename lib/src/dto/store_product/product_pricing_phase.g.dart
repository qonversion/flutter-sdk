// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_pricing_phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductPricingPhase _$QProductPricingPhaseFromJson(Map<String, dynamic> json) {
  return QProductPricingPhase(
    QMapper.requiredProductPriceFromJson(json['price']),
    QMapper.requiredSubscriptionPeriodFromJson(json['billingPeriod']),
    json['billingCycleCount'] as int,
    _$enumDecode(_$QPricingPhaseRecurrenceModeEnumMap, json['recurrenceMode'],
        unknownValue: QPricingPhaseRecurrenceMode.unknown),
    _$enumDecode(_$QPricingPhaseTypeEnumMap, json['type'],
        unknownValue: QPricingPhaseType.unknown),
    json['isTrial'] as bool,
    json['isIntro'] as bool,
    json['isBasePlan'] as bool,
  );
}

Map<String, dynamic> _$QProductPricingPhaseToJson(
        QProductPricingPhase instance) =>
    <String, dynamic>{
      'price': instance.price,
      'billingPeriod': instance.billingPeriod,
      'billingCycleCount': instance.billingCycleCount,
      'recurrenceMode':
          _$QPricingPhaseRecurrenceModeEnumMap[instance.recurrenceMode],
      'type': _$QPricingPhaseTypeEnumMap[instance.type],
      'isTrial': instance.isTrial,
      'isIntro': instance.isIntro,
      'isBasePlan': instance.isBasePlan,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$QPricingPhaseRecurrenceModeEnumMap = {
  QPricingPhaseRecurrenceMode.infiniteRecurring: 'InfiniteRecurring',
  QPricingPhaseRecurrenceMode.finiteRecurring: 'FiniteRecurring',
  QPricingPhaseRecurrenceMode.nonRecurring: 'NonRecurring',
  QPricingPhaseRecurrenceMode.unknown: 'Unknown',
};

const _$QPricingPhaseTypeEnumMap = {
  QPricingPhaseType.regular: 'Regular',
  QPricingPhaseType.freeTrial: 'FreeTrial',
  QPricingPhaseType.singlePayment: 'SinglePayment',
  QPricingPhaseType.discountedRecurringPayment: 'DiscountedRecurringPayment',
  QPricingPhaseType.unknown: 'Unknown',
};
