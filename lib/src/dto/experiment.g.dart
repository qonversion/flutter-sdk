// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QExperiment _$QExperimentFromJson(Map<String, dynamic> json) {
  return QExperiment(
    json['id'] as String,
    json['name'] as String,
    QExperimentGroup.fromJson(json['group'] as Map<String, dynamic>),
  );
}
