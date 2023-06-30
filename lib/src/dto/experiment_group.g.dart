// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QExperimentGroup _$QExperimentGroupFromJson(Map<String, dynamic> json) {
  return QExperimentGroup(
    json['id'] as String,
    json['name'] as String,
    _$enumDecode(_$QExperimentGroupTypeEnumMap, json['type'],
        unknownValue: QExperimentGroupType.unknown),
  );
}

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

const _$QExperimentGroupTypeEnumMap = {
  QExperimentGroupType.unknown: 'unknown',
  QExperimentGroupType.treatment: 'treatment',
  QExperimentGroupType.control: 'control',
};
