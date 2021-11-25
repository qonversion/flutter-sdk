// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QPermission _$QPermissionFromJson(Map<String, dynamic> json) {
  return QPermission(
    json['id'] as String,
    json['associated_product'] as String,
    _$enumDecode(_$QProductRenewStateEnumMap, json['renew_state'],
        unknownValue: QProductRenewState.unknown),
    QMapper.dateTimeFromNullableSecondsTimestamp(
        json['started_timestamp'] as num?),
    QMapper.dateTimeFromNullableSecondsTimestamp(
        json['expiration_timestamp'] as num?),
    json['active'] as bool,
  );
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$QProductRenewStateEnumMap = {
  QProductRenewState.nonRenewable: -1,
  QProductRenewState.unknown: 0,
  QProductRenewState.willRenew: 1,
  QProductRenewState.canceled: 2,
  QProductRenewState.billingIssue: 3,
};
