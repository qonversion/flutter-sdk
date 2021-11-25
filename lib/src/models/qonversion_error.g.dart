// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qonversion_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QError _$QErrorFromJson(Map<String, dynamic> json) {
  return QError(
    json['code'] as String,
    json['description'] as String,
    json['additionalMessage'] as String?,
  );
}

Map<String, dynamic> _$QErrorToJson(QError instance) => <String, dynamic>{
      'code': instance.code,
      'description': instance.message,
      'additionalMessage': instance.details,
    };
