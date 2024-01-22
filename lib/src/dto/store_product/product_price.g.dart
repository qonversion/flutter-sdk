// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductPrice _$QProductPriceFromJson(Map<String, dynamic> json) {
  return QProductPrice(
    json['priceAmountMicros'] as int,
    json['priceCurrencyCode'] as String,
    json['formattedPrice'] as String,
    json['isFree'] as bool,
    json['currencySymbol'] as String?,
  );
}

Map<String, dynamic> _$QProductPriceToJson(QProductPrice instance) =>
    <String, dynamic>{
      'priceAmountMicros': instance.priceAmountMicros,
      'priceCurrencyCode': instance.priceCurrencyCode,
      'formattedPrice': instance.formattedPrice,
      'isFree': instance.isFree,
      'currencySymbol': instance.currencySymbol,
    };
