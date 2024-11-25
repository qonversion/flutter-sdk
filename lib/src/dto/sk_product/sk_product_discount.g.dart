// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sk_product_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SKProductDiscount _$SKProductDiscountFromJson(Map<String, dynamic> json) =>
    SKProductDiscount(
      identifier: json['identifier'] as String?,
      price: json['price'] as String,
      priceLocale: QMapper.skPriceLocaleFromJson(json['priceLocale']),
      numberOfPeriods: (json['numberOfPeriods'] as num).toInt(),
      paymentMode: $enumDecode(
          _$SKProductDiscountPaymentModeEnumMap, json['paymentMode']),
      subscriptionPeriod: QMapper.skProductSubscriptionPeriodFromJson(
          json['subscriptionPeriod']),
    );

Map<String, dynamic> _$SKProductDiscountToJson(SKProductDiscount instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'price': instance.price,
      'priceLocale': instance.priceLocale,
      'numberOfPeriods': instance.numberOfPeriods,
      'paymentMode':
          _$SKProductDiscountPaymentModeEnumMap[instance.paymentMode]!,
      'subscriptionPeriod': instance.subscriptionPeriod,
    };

const _$SKProductDiscountPaymentModeEnumMap = {
  SKProductDiscountPaymentMode.payAsYouGo: 0,
  SKProductDiscountPaymentMode.payUpFront: 1,
  SKProductDiscountPaymentMode.freeTrial: 2,
};
