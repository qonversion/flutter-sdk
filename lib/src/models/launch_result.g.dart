// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QLaunchResult _$QLaunchResultFromJson(Map<String, dynamic> json) {
  return QLaunchResult(
    json['uid'] as String,
    QMapper.dateTimeFromSecondsTimestamp(json['timestamp'] as num?),
    QMapper.productsFromJson(json['products']),
    QMapper.permissionsFromJson(json['permissions']),
    QMapper.productsFromJson(json['user_products']),
  );
}
