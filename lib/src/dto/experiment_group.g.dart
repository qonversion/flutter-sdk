// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QExperimentGroup _$QExperimentGroupFromJson(Map<String, dynamic> json) =>
    QExperimentGroup(
      json['id'] as String,
      json['name'] as String,
      $enumDecode(_$QExperimentGroupTypeEnumMap, json['type'],
          unknownValue: QExperimentGroupType.unknown),
    );

const _$QExperimentGroupTypeEnumMap = {
  QExperimentGroupType.unknown: 'unknown',
  QExperimentGroupType.treatment: 'treatment',
  QExperimentGroupType.control: 'control',
};
