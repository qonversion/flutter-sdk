// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QPermission _$QPermissionFromJson(Map<String, dynamic> json) {
  return QPermission(
    json['permission_id'] as String,
    json['product_id'] as String,
    _$enumDecodeNullable(_$QProductRenewStateEnumMap, json['renew_state'],
        unknownValue: QProductRenewState.unknown),
    json['started_date'] == null
        ? null
        : DateTime.parse(json['started_date'] as String),
    json['expiration_date'] == null
        ? null
        : DateTime.parse(json['expiration_date'] as String),
    json['is_active'] as bool,
  );
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$QProductRenewStateEnumMap = {
  QProductRenewState.nonRenewable: -1,
  QProductRenewState.unknown: 0,
  QProductRenewState.willRenew: 1,
  QProductRenewState.canceled: 2,
  QProductRenewState.billingIssue: 3,
};
