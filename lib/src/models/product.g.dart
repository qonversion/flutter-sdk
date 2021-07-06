// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProduct _$QProductFromJson(Map<String, dynamic> json) {
  return QProduct(
    json['id'] as String,
    json['store_id'] as String?,
    _$enumDecode(_$QProductTypeEnumMap, json['type'],
        unknownValue: QProductType.unknown),
    _$enumDecodeNullable(_$QProductDurationEnumMap, json['duration'],
        unknownValue: QProductDuration.unknown),
    json['pretty_price'] as String?,
    _$enumDecodeNullable(_$QTrialDurationEnumMap, json['trial_duration']),
    QMapper.skProductFromJson(json['sk_product']),
    QMapper.skuDetailsFromJson(json['sku_details']),
    json['offering_id'] as String?,
  );
}

Map<String, dynamic> _$QProductToJson(QProduct instance) => <String, dynamic>{
      'id': instance.qonversionId,
      'store_id': instance.storeId,
      'type': _$QProductTypeEnumMap[instance.type],
      'duration': _$QProductDurationEnumMap[instance.duration],
      'pretty_price': instance.prettyPrice,
      'trial_duration': _$QTrialDurationEnumMap[instance.trialDuration],
      'sk_product': instance.skProduct,
      'sku_details': instance.skuDetails,
      'offering_id': instance.offeringID,
    };

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

const _$QProductTypeEnumMap = {
  QProductType.trial: 0,
  QProductType.subscription: 1,
  QProductType.inApp: 2,
  QProductType.unknown: 'unknown',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$QProductDurationEnumMap = {
  QProductDuration.weekly: 0,
  QProductDuration.monthly: 1,
  QProductDuration.threeMonths: 2,
  QProductDuration.sixMonths: 3,
  QProductDuration.annual: 4,
  QProductDuration.lifetime: 5,
  QProductDuration.unknown: 'unknown',
};

const _$QTrialDurationEnumMap = {
  QTrialDuration.notAvailable: -1,
  QTrialDuration.threeDays: 1,
  QTrialDuration.week: 2,
  QTrialDuration.twoWeeks: 3,
  QTrialDuration.month: 4,
  QTrialDuration.twoMonths: 5,
  QTrialDuration.threeMonths: 6,
  QTrialDuration.sixMonths: 7,
  QTrialDuration.year: 8,
  QTrialDuration.other: 9,
};
