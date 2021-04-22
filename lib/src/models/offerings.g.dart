// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offerings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QOfferings _$QOfferingsFromJson(Map<String, dynamic> json) {
  return QOfferings(
    json['main'] == null
        ? null
        : QOffering.fromJson(json['main'] as Map<String, dynamic>),
    (json['available_offerings'] as List<dynamic>)
        .map((e) => QOffering.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

QOffering _$QOfferingFromJson(Map<String, dynamic> json) {
  return QOffering(
    json['id'] as String,
    _$enumDecode(_$QOfferingTagEnumMap, json['tag']),
    (json['products'] as List<dynamic>)
        .map((e) => QProduct.fromJson(e as Map<String, dynamic>))
        .toList(),
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

const _$QOfferingTagEnumMap = {
  QOfferingTag.none: 0,
  QOfferingTag.main: 1,
};
