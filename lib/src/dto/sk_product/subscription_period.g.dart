// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SKProductSubscriptionPeriod _$SKProductSubscriptionPeriodFromJson(
        Map<String, dynamic> json) =>
    SKProductSubscriptionPeriod(
      numberOfUnits: (json['numberOfUnits'] as num).toInt(),
      unit: $enumDecode(_$SKSubscriptionPeriodUnitEnumMap, json['unit']),
    );

Map<String, dynamic> _$SKProductSubscriptionPeriodToJson(
        SKProductSubscriptionPeriod instance) =>
    <String, dynamic>{
      'numberOfUnits': instance.numberOfUnits,
      'unit': _$SKSubscriptionPeriodUnitEnumMap[instance.unit]!,
    };

const _$SKSubscriptionPeriodUnitEnumMap = {
  SKSubscriptionPeriodUnit.day: 0,
  SKSubscriptionPeriodUnit.week: 1,
  SKSubscriptionPeriodUnit.month: 2,
  SKSubscriptionPeriodUnit.year: 3,
};
