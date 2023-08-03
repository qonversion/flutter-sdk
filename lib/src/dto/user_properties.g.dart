// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QUserProperties _$QUserPropertiesFromJson(Map<String, dynamic> json) {
  return QUserProperties(
    (json['properties'] as List<dynamic>)
        .map((e) => QUserProperty.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
