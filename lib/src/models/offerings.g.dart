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
    (json['available_offerings'] as List)
        ?.map((e) =>
            e == null ? null : QOffering.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

QOffering _$QOfferingFromJson(Map<String, dynamic> json) {
  return QOffering(
    json['id'] as String,
    json['tag'] as int,
    (json['products'] as List)
        ?.map((e) =>
            e == null ? null : QProduct.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
