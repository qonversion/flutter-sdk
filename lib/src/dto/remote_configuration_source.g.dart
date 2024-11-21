// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_configuration_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRemoteConfigurationSource _$QRemoteConfigurationSourceFromJson(
        Map<String, dynamic> json) =>
    QRemoteConfigurationSource(
      json['id'] as String,
      json['name'] as String,
      $enumDecode(_$QRemoteConfigurationSourceTypeEnumMap, json['type'],
          unknownValue: QRemoteConfigurationSourceType.unknown),
      $enumDecode(
          _$QRemoteConfigurationAssignmentTypeEnumMap, json['assignmentType'],
          unknownValue: QRemoteConfigurationAssignmentType.unknown),
      json['contextKey'] as String?,
    );

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
