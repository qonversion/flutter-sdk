// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotional_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QPromotionalOffer _$QPromotionalOfferFromJson(Map<String, dynamic> json) =>
    QPromotionalOffer(
      QMapper.requiredSkProductDiscountFromJson(json['productDiscount']),
      QMapper.skPaymentDiscountFromJson(json['paymentDiscount']),
    );

Map<String, dynamic> _$QPromotionalOfferToJson(QPromotionalOffer instance) =>
    <String, dynamic>{
      'productDiscount': instance.productDiscount,
      'paymentDiscount': instance.paymentDiscount,
    };
