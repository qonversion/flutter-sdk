// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sk_payment_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SKPaymentDiscount _$SKPaymentDiscountFromJson(Map<String, dynamic> json) =>
    SKPaymentDiscount(
      identifier: json['identifier'] as String,
      keyIdentifier: json['keyIdentifier'] as String,
      nonce: json['nonce'] as String,
      signature: json['signature'] as String,
      timestamp: json['timestamp'] as num,
    );

Map<String, dynamic> _$SKPaymentDiscountToJson(SKPaymentDiscount instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'keyIdentifier': instance.keyIdentifier,
      'nonce': instance.nonce,
      'signature': instance.signature,
      'timestamp': instance.timestamp,
    };
