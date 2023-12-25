import 'package:json_annotation/json_annotation.dart';

part 'product_price.g.dart';

/// Information about the Google product's price.
@JsonSerializable()
class QProductPrice {
  /// Total amount of money in micro-units,
  /// where 1,000,000 micro-units equal one unit of the currency.
  @JsonKey(name: 'priceAmountMicros')
  final int priceAmountMicros;

  /// ISO 4217 currency code for price.
  @JsonKey(name: 'priceCurrencyCode')
  final String priceCurrencyCode;

  /// Formatted price for the payment, including its currency sign.
  @JsonKey(name: 'formattedPrice')
  final String formattedPrice;

  /// True, if the price is zero. False otherwise.
  @JsonKey(name: 'isFree')
  final bool isFree;

  /// Price currency symbol. Null if failed to parse.
  @JsonKey(name: 'currencySymbol')
  final String? currencySymbol;

  const QProductPrice(
      this.priceAmountMicros,
      this.priceCurrencyCode,
      this.formattedPrice,
      this.isFree,
      this.currencySymbol,
  );

  factory QProductPrice.fromJson(Map<String, dynamic> json) =>
      _$QProductPriceFromJson(json);

  Map<String, dynamic> toJson() => _$QProductPriceToJson(this);
}