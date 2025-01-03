// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductStoreDetails _$QProductStoreDetailsFromJson(
        Map<String, dynamic> json) =>
    QProductStoreDetails(
      json['basePlanId'] as String?,
      json['productId'] as String,
      json['name'] as String,
      json['title'] as String,
      json['description'] as String,
      QMapper.productOfferDetailsListFromJson(json['subscriptionOfferDetails']),
      QMapper.productOfferDetailsFromJson(
          json['defaultSubscriptionOfferDetails']),
      QMapper.productOfferDetailsFromJson(
          json['basePlanSubscriptionOfferDetails']),
      QMapper.productInAppDetailsFromJson(json['inAppOfferDetails']),
      json['hasTrialOffer'] as bool,
      json['hasIntroOffer'] as bool,
      json['hasTrialOrIntroOffer'] as bool,
      $enumDecode(_$QProductTypeEnumMap, json['productType'],
          unknownValue: QProductType.unknown),
      json['isInApp'] as bool,
      json['isSubscription'] as bool,
      json['isPrepaid'] as bool,
      json['isInstallment'] as bool,
    );

Map<String, dynamic> _$QProductStoreDetailsToJson(
        QProductStoreDetails instance) =>
    <String, dynamic>{
      'basePlanId': instance.basePlanId,
      'productId': instance.productId,
      'name': instance.name,
      'title': instance.title,
      'description': instance.description,
      'subscriptionOfferDetails': instance.subscriptionOfferDetails,
      'defaultSubscriptionOfferDetails':
          instance.defaultSubscriptionOfferDetails,
      'basePlanSubscriptionOfferDetails':
          instance.basePlanSubscriptionOfferDetails,
      'inAppOfferDetails': instance.inAppOfferDetails,
      'hasTrialOffer': instance.hasTrialOffer,
      'hasIntroOffer': instance.hasIntroOffer,
      'hasTrialOrIntroOffer': instance.hasTrialOrIntroOffer,
      'productType': _$QProductTypeEnumMap[instance.productType]!,
      'isInApp': instance.isInApp,
      'isSubscription': instance.isSubscription,
      'isPrepaid': instance.isPrepaid,
      'isInstallment': instance.isInstallment,
    };

const _$QProductTypeEnumMap = {
  QProductType.trial: 'Trial',
  QProductType.intro: 'Intro',
  QProductType.subscription: 'Subscription',
  QProductType.inApp: 'InApp',
  QProductType.unknown: 'Unknown',
};
