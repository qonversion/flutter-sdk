// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:collection/collection.dart' show IterableExtension;
part of 'offerings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QOfferings _$QOfferingsFromJson(Map<String, dynamic> json) {
  return QOfferings(
    json['main'] == null
        ? null
        : QOffering.fromJson(json['main'] as Map<String, dynamic>),
    (json['available_offerings'] as List?)
        ?.map((e) =>
            e == null ? null : QOffering.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

QOffering _$QOfferingFromJson(Map<String, dynamic> json) {
  return QOffering(
    json['id'] as String,
    _$enumDecodeNullable(_$QOfferingTagEnumMap, json['tag'])!,
    (json['products'] as List?)
        ?.map((e) =>
            e == null ? null : QProduct.fromJson(e as Map<String, dynamic>))
        ?.toList(),
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

const _$QOfferingTagEnumMap = {
  QOfferingTag.none: 0,
  QOfferingTag.main: 1,
};
