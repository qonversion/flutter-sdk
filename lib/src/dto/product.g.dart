// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProduct _$QProductFromJson(Map<String, dynamic> json) => QProduct(
      json['id'] as String,
      json['storeId'] as String?,
      json['basePlanId'] as String?,
      QMapper.skuDetailsFromJson(json['skuDetails']),
      QMapper.storeProductDetailsFromJson(json['storeDetails']),
      QMapper.skProductFromJson(json['skProduct']),
      json['offeringId'] as String?,
      QMapper.subscriptionPeriodFromJson(json['subscriptionPeriod']),
      QMapper.subscriptionPeriodFromJson(json['trialPeriod']),
      $enumDecode(_$QProductTypeEnumMap, json['type'],
          unknownValue: QProductType.unknown),
      json['prettyPrice'] as String?,
    );

Map<String, dynamic> _$QProductToJson(QProduct instance) => <String, dynamic>{
      'id': instance.qonversionId,
      'storeId': instance.storeId,
      'basePlanId': instance.basePlanId,
      'skuDetails': instance.skuDetails,
      'storeDetails': instance.storeDetails,
      'skProduct': instance.skProduct,
      'offeringId': instance.offeringId,
      'subscriptionPeriod': instance.subscriptionPeriod,
      'trialPeriod': instance.trialPeriod,
      'type': _$QProductTypeEnumMap[instance.type]!,
      'prettyPrice': instance.prettyPrice,
    };

const _$QProductTypeEnumMap = {
  QProductType.trial: 'Trial',
  QProductType.intro: 'Intro',
  QProductType.subscription: 'Subscription',
  QProductType.inApp: 'InApp',
  QProductType.unknown: 'Unknown',
};
