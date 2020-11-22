// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QLaunchResult _$QLaunchResultFromJson(Map<String, dynamic> json) {
  return QLaunchResult(
    json['uid'] as String,
    _dateTimeFromTimestamp(json['timestamp'] as int),
    _productsFromJson(json['products']),
    _permissionsFromJson(json['permissions']),
    _productsFromJson(json['user_products']),
  );
}
