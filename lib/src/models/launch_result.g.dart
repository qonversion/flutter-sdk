// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QLaunchResult _$QLaunchResultFromJson(Map<String, dynamic> json) {
  return QLaunchResult(
    json['uid'] as String,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    (json['products'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k,
              e == null ? null : QProduct.fromJson(e as Map<String, dynamic>)),
        ) ??
        {},
    (json['permissions'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(
              k,
              e == null
                  ? null
                  : QPermission.fromJson(e as Map<String, dynamic>)),
        ) ??
        {},
    (json['user_products'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k,
              e == null ? null : QProduct.fromJson(e as Map<String, dynamic>)),
        ) ??
        {},
  );
}
