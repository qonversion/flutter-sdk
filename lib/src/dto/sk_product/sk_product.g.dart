// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sk_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SKProduct _$SKProductFromJson(Map<String, dynamic> json) => SKProduct(
      productIdentifier: json['productIdentifier'] as String,
      localizedTitle: json['localizedTitle'] as String?,
      localizedDescription: json['localizedDescription'] as String?,
      priceLocale: QMapper.skPriceLocaleFromJson(json['priceLocale']),
      subscriptionGroupIdentifier:
          json['subscriptionGroupIdentifier'] as String?,
      price: json['price'] as String,
      subscriptionPeriod: QMapper.skProductSubscriptionPeriodFromJson(
          json['subscriptionPeriod']),
      introductoryPrice:
          QMapper.skProductDiscountFromJson(json['introductoryPrice']),
      productDiscount:
          QMapper.skProductDiscountFromJson(json['productDiscount']),
      discounts: QMapper.skProductDiscountsFromList(json['discounts'] as List?),
    );

Map<String, dynamic> _$SKProductToJson(SKProduct instance) => <String, dynamic>{
      'productIdentifier': instance.productIdentifier,
      'localizedTitle': instance.localizedTitle,
      'localizedDescription': instance.localizedDescription,
      'priceLocale': instance.priceLocale,
      'subscriptionGroupIdentifier': instance.subscriptionGroupIdentifier,
      'price': instance.price,
      'subscriptionPeriod': instance.subscriptionPeriod,
      'introductoryPrice': instance.introductoryPrice,
      'productDiscount': instance.productDiscount,
      'discounts': instance.discounts,
    };

SKPriceLocale _$SKPriceLocaleFromJson(Map<String, dynamic> json) =>
    SKPriceLocale(
      currencySymbol: json['currencySymbol'] as String?,
      currencyCode: json['currencyCode'] as String?,
    );

Map<String, dynamic> _$SKPriceLocaleToJson(SKPriceLocale instance) =>
    <String, dynamic>{
      'currencySymbol': instance.currencySymbol,
      'currencyCode': instance.currencyCode,
    };
