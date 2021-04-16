// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sk_product_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SKProductWrapper _$SKProductWrapperFromJson(Map<String, dynamic> json) {
  return SKProductWrapper(
    productIdentifier: json['productIdentifier'] as String,
    localizedTitle: json['localizedTitle'] as String?,
    localizedDescription: json['localizedDescription'] as String?,
    priceLocale: QMapper.skPriceLocaleFromJson(json['priceLocale'])!,
    subscriptionGroupIdentifier: json['subscriptionGroupIdentifier'] as String?,
    price: json['price'] as String,
    subscriptionPeriod:
        QMapper.skProductSubscriptionPeriodFromJson(json['subscriptionPeriod']),
    introductoryPrice:
        QMapper.skProductDiscountFromJson(json['introductoryPrice']),
  );
}

Map<String, dynamic> _$SKProductWrapperToJson(SKProductWrapper instance) =>
    <String, dynamic>{
      'productIdentifier': instance.productIdentifier,
      'localizedTitle': instance.localizedTitle,
      'localizedDescription': instance.localizedDescription,
      'priceLocale': instance.priceLocale,
      'subscriptionGroupIdentifier': instance.subscriptionGroupIdentifier,
      'price': instance.price,
      'subscriptionPeriod': instance.subscriptionPeriod,
      'introductoryPrice': instance.introductoryPrice,
    };

SKPriceLocaleWrapper _$SKPriceLocaleWrapperFromJson(Map<String, dynamic> json) {
  return SKPriceLocaleWrapper(
    currencySymbol: json['currencySymbol'] as String?,
    currencyCode: json['currencyCode'] as String?,
  );
}

Map<String, dynamic> _$SKPriceLocaleWrapperToJson(
        SKPriceLocaleWrapper instance) =>
    <String, dynamic>{
      'currencySymbol': instance.currencySymbol,
      'currencyCode': instance.currencyCode,
    };
