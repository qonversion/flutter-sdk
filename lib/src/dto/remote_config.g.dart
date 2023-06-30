// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRemoteConfig _$QRemoteConfigFromJson(Map<String, dynamic> json) {
  return QRemoteConfig(
    json['payload'] as Map<String, dynamic>,
    json['experiment'] == null
        ? null
        : QExperiment.fromJson(json['experiment'] as Map<String, dynamic>),
  );
}
