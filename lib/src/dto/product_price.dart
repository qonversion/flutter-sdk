
class QProductPrice {
  /// Currency symbol
  @JsonKey(ignore: true)
  String? currencySymbol;

  /// Formatted price
  @JsonKey(ignore: true)
  String formattedPrice;

  /// Free price flag
  @JsonKey(ignore: true)
  bool isFree;

  /// Price amount micros
  @JsonKey(ignore: true)
  int priceAmountMicros;

  /// Currency code
  @JsonKey(ignore: true)
  String priceCurrencyCode;

  const QProductPrice(
      this.currencySymbol,
      this.formattedPrice,
      this.isFree,
      this.priceAmountMicros,
      this.priceCurrencyCode);

  factory QProductPrice.fromJson(Map<String, dynamic> json) =>
      _$QProductPrice(json);

  Map<String, dynamic> toJson() => _$QProductPrice(this);
}