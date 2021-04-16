// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:collection/collection.dart' show IterableExtension;
part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SKProductDiscountWrapper _$SKProductDiscountWrapperFromJson(
    Map<String, dynamic> json) {
  return SKProductDiscountWrapper(
    price: json['price'] as String,
    priceLocale: QMapper.skPriceLocaleFromJson(json['priceLocale']),
    numberOfPeriods: json['numberOfPeriods'] as int,
    paymentMode: _$enumDecodeNullable(
        _$SKProductDiscountPaymentModeEnumMap, json['paymentMode'])!,
    subscriptionPeriod:
        QMapper.skProductSubscriptionPeriodFromJson(json['subscriptionPeriod']),
  );
}

Map<String, dynamic> _$SKProductDiscountWrapperToJson(
        SKProductDiscountWrapper instance) =>
    <String, dynamic>{
      'price': instance.price,
      'priceLocale': instance.priceLocale,
      'numberOfPeriods': instance.numberOfPeriods,
      'paymentMode':
          _$SKProductDiscountPaymentModeEnumMap[instance.paymentMode],
      'subscriptionPeriod': instance.subscriptionPeriod,
    };

T? _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhereOrNull((e) => e.value == source)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T? _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SKProductDiscountPaymentModeEnumMap = {
  SKProductDiscountPaymentMode.payAsYouGo: 0,
  SKProductDiscountPaymentMode.payUpFront: 1,
  SKProductDiscountPaymentMode.freeTrail: 2,
};
