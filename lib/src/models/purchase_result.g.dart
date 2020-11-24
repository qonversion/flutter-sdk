// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QPurchaseResult _$QPurchaseResultFromJson(Map<String, dynamic> json) {
  return QPurchaseResult(
    QMapper.permissionsFromJson(json['permissions']),
    json['error'] as String,
    json['is_cancelled'] as bool,
  );
}
