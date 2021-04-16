// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:collection/collection.dart' show IterableExtension;
part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QPermission _$QPermissionFromJson(Map<String, dynamic> json) {
  return QPermission(
    json['id'] as String,
    json['associated_product'] as String,
    _$enumDecodeNullable(_$QProductRenewStateEnumMap, json['renew_state'],
        unknownValue: QProductRenewState.unknown)!,
    QMapper.dateTimeFromSecondsTimestamp(json['started_timestamp'] as num?)!,
    QMapper.dateTimeFromSecondsTimestamp(json['expiration_timestamp'] as num?),
    json['active'] as bool,
  );
}

T? _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhereOrNull((e) => e.value == source)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T? _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
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
