// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QUser _$QUserFromJson(Map<String, dynamic> json) {
  return QUser(
    json['qonversionId'] as String,
    json['identityId'] as String,
  );
}

Map<String, dynamic> _$QUserToJson(QUser instance) => <String, dynamic>{
      'qonversionId': instance.qonversionId,
      'identityId': instance.identityId,
    };
