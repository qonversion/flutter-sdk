import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/product_price.dart';

@JsonSerializable()
class QProductInAppDetails {
  /// Product price details
  @JsonKey(ignore: true)
  QProductPrice price;

  const QProductInAppDetails(this.price);

  factory QProductInAppDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductInAppDetails(json);

  Map<String, dynamic> toJson() => _$QProductInAppDetails(this);
}

