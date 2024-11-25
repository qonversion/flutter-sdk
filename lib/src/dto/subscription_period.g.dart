// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QSubscriptionPeriod _$QSubscriptionPeriodFromJson(Map<String, dynamic> json) =>
    QSubscriptionPeriod(
      (json['unitCount'] as num).toInt(),
      $enumDecode(_$QSubscriptionPeriodUnitEnumMap, json['unit'],
          unknownValue: QSubscriptionPeriodUnit.unknown),
      json['iso'] as String,
    );

Map<String, dynamic> _$QSubscriptionPeriodToJson(
        QSubscriptionPeriod instance) =>
    <String, dynamic>{
      'unitCount': instance.unitCount,
      'unit': _$QSubscriptionPeriodUnitEnumMap[instance.unit]!,
      'iso': instance.iso,
    };

const _$QSubscriptionPeriodUnitEnumMap = {
  QSubscriptionPeriodUnit.day: 'Day',
  QSubscriptionPeriodUnit.week: 'Week',
  QSubscriptionPeriodUnit.month: 'Month',
  QSubscriptionPeriodUnit.year: 'Year',
  QSubscriptionPeriodUnit.unknown: 'Unknown',
};
