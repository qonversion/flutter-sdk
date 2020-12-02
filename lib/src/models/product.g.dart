// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProduct _$QProductFromJson(Map<String, dynamic> json) {
  return QProduct(
    json['id'] as String,
    json['store_id'] as String,
    _$enumDecodeNullable(_$QProductTypeEnumMap, json['type'],
        unknownValue: QProductType.unknown),
    _$enumDecodeNullable(_$QProductDurationEnumMap, json['duration'],
        unknownValue: QProductDuration.unknown),
    QMapper.skProductFromJson(json['sk_product']),
  );
}

Map<String, dynamic> _$QProductToJson(QProduct instance) => <String, dynamic>{
      'id': instance.qonversionId,
      'store_id': instance.storeId,
      'type': _$QProductTypeEnumMap[instance.type],
      'duration': _$QProductDurationEnumMap[instance.duration],
      'sk_product': instance.skProduct,
    };

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

const _$QProductTypeEnumMap = {
  QProductType.trial: 0,
  QProductType.subscription: 1,
  QProductType.inApp: 2,
  QProductType.unknown: 'unknown',
};

const _$QProductDurationEnumMap = {
  QProductDuration.weekly: 0,
  QProductDuration.monthly: 1,
  QProductDuration.threeMonths: 2,
  QProductDuration.sixMonths: 3,
  QProductDuration.annual: 4,
  QProductDuration.lifetime: 5,
  QProductDuration.unknown: 'unknown',
};
