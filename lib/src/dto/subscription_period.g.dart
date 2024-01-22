// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QSubscriptionPeriod _$QSubscriptionPeriodFromJson(Map<String, dynamic> json) {
  return QSubscriptionPeriod(
    json['unitCount'] as int,
    _$enumDecode(_$QSubscriptionPeriodUnitEnumMap, json['unit'],
        unknownValue: QSubscriptionPeriodUnit.unknown),
    json['iso'] as String,
  );
}

Map<String, dynamic> _$QSubscriptionPeriodToJson(
        QSubscriptionPeriod instance) =>
    <String, dynamic>{
      'unitCount': instance.unitCount,
      'unit': _$QSubscriptionPeriodUnitEnumMap[instance.unit],
      'iso': instance.iso,
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

const _$QSubscriptionPeriodUnitEnumMap = {
  QSubscriptionPeriodUnit.day: 'Day',
  QSubscriptionPeriodUnit.week: 'Week',
  QSubscriptionPeriodUnit.month: 'Month',
  QSubscriptionPeriodUnit.year: 'Year',
  QSubscriptionPeriodUnit.unknown: 'Unknown',
};
