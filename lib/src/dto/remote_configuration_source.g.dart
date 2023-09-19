// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_configuration_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRemoteConfigurationSource _$QRemoteConfigurationSourceFromJson(
    Map<String, dynamic> json) {
  return QRemoteConfigurationSource(
    json['id'] as String,
    json['name'] as String,
    _$enumDecode(_$QRemoteConfigurationSourceTypeEnumMap, json['type'],
        unknownValue: QRemoteConfigurationSourceType.unknown),
    _$enumDecode(
        _$QRemoteConfigurationAssignmentTypeEnumMap, json['assignmentType'],
        unknownValue: QRemoteConfigurationAssignmentType.unknown),
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

const _$QRemoteConfigurationSourceTypeEnumMap = {
  QRemoteConfigurationSourceType.unknown: 'unknown',
  QRemoteConfigurationSourceType.experimentTreatmentGroup:
      'experiment_treatment_group',
  QRemoteConfigurationSourceType.experimentControlGroup:
      'experiment_control_group',
  QRemoteConfigurationSourceType.remoteConfiguration: 'remote_configuration',
};

const _$QRemoteConfigurationAssignmentTypeEnumMap = {
  QRemoteConfigurationAssignmentType.unknown: 'unknown',
  QRemoteConfigurationAssignmentType.auto: 'auto',
  QRemoteConfigurationAssignmentType.manual: 'manual',
};
