// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkuDetailsWrapper _$SkuDetailsWrapperFromJson(Map<String, dynamic> json) =>
    SkuDetailsWrapper(
      description: json['description'] as String,
      freeTrialPeriod: json['freeTrialPeriod'] as String,
      introductoryPrice: json['introductoryPrice'] as String,
      introductoryPriceAmountMicros:
          (json['introductoryPriceAmountMicros'] as num).toInt(),
      introductoryPriceCycles: (json['introductoryPriceCycles'] as num).toInt(),
      introductoryPricePeriod: json['introductoryPricePeriod'] as String,
      price: json['price'] as String,
      priceAmountMicros: (json['priceAmountMicros'] as num).toInt(),
      priceCurrencyCode: json['priceCurrencyCode'] as String,
      sku: json['sku'] as String,
      subscriptionPeriod: json['subscriptionPeriod'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$SkuTypeEnumMap, json['type']),
      originalPrice: json['originalPrice'] as String,
      originalPriceAmountMicros:
          (json['originalPriceAmountMicros'] as num).toInt(),
      originalJson: json['originalJson'] as String,
    );

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
      'type': _$SkuTypeEnumMap[instance.type]!,
      'originalPrice': instance.originalPrice,
      'originalPriceAmountMicros': instance.originalPriceAmountMicros,
      'originalJson': instance.originalJson,
    };

const _$SkuTypeEnumMap = {
  SkuType.inapp: 'inapp',
  SkuType.subs: 'subs',
};
