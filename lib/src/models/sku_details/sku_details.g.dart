// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkuDetailsWrapper _$SkuDetailsWrapperFromJson(Map<String, dynamic> json) {
  return SkuDetailsWrapper(
    description: json['description'] as String,
    freeTrialPeriod: json['freeTrialPeriod'] as String,
    introductoryPrice: json['introductoryPrice'] as String,
    introductoryPriceAmountMicros: json['introductoryPriceAmountMicros'] as int,
    introductoryPriceCycles: json['introductoryPriceCycles'] as int,
    introductoryPricePeriod: json['introductoryPricePeriod'] as String,
    price: json['price'] as String,
    priceAmountMicros: json['priceAmountMicros'] as int,
    priceCurrencyCode: json['priceCurrencyCode'] as String,
    sku: json['sku'] as String,
    subscriptionPeriod: json['subscriptionPeriod'] as String,
    title: json['title'] as String,
    type: _$enumDecode(_$SkuTypeEnumMap, json['type']),
    originalPrice: json['originalPrice'] as String,
    originalPriceAmountMicros: json['originalPriceAmountMicros'] as int,
    originalJson: json['originalJson'] as String,
  );
}

Map<String, dynamic> _$SkuDetailsWrapperToJson(SkuDetailsWrapper instance) =>
    <String, dynamic>{
      'description': instance.description,
      'freeTrialPeriod': instance.freeTrialPeriod,
      'introductoryPrice': instance.introductoryPrice,
      'introductoryPriceAmountMicros': instance.introductoryPriceAmountMicros,
      'introductoryPriceCycles': instance.introductoryPriceCycles,
      'introductoryPricePeriod': instance.introductoryPricePeriod,
      'price': instance.price,
      'priceAmountMicros': instance.priceAmountMicros,
      'priceCurrencyCode': instance.priceCurrencyCode,
      'sku': instance.sku,
      'subscriptionPeriod': instance.subscriptionPeriod,
      'title': instance.title,
      'type': _$SkuTypeEnumMap[instance.type],
      'originalPrice': instance.originalPrice,
      'originalPriceAmountMicros': instance.originalPriceAmountMicros,
      'originalJson': instance.originalJson,
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

const _$SkuTypeEnumMap = {
  SkuType.inapp: 'inapp',
  SkuType.subs: 'subs',
};
