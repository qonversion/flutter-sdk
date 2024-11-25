// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_inapp_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductInAppDetails _$QProductInAppDetailsFromJson(
        Map<String, dynamic> json) =>
    QProductInAppDetails(
      QMapper.requiredProductPriceFromJson(json['price']),
    );

Map<String, dynamic> _$QProductInAppDetailsToJson(
        QProductInAppDetails instance) =>
    <String, dynamic>{
      'price': instance.price,
    };
