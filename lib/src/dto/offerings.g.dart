// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offerings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QOfferings _$QOfferingsFromJson(Map<String, dynamic> json) => QOfferings(
      json['main'] == null
          ? null
          : QOffering.fromJson(json['main'] as Map<String, dynamic>),
      (json['availableOfferings'] as List<dynamic>)
          .map((e) => QOffering.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

QOffering _$QOfferingFromJson(Map<String, dynamic> json) => QOffering(
      json['id'] as String,
      $enumDecode(_$QOfferingTagEnumMap, json['tag']),
      (json['products'] as List<dynamic>)
          .map((e) => QProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

const _$QOfferingTagEnumMap = {
  QOfferingTag.unknown: -1,
  QOfferingTag.none: 0,
  QOfferingTag.main: 1,
};
