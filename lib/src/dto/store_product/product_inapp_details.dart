import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

import './product_price.dart';

part 'product_inapp_details.g.dart';

/// This class contains all the information about the Google in-app product details.
@JsonSerializable()
class QProductInAppDetails {
  /// The price of an in-app product.
  @JsonKey(name: 'price', fromJson: QMapper.requiredProductPriceFromJson)
  final QProductPrice price;

  const QProductInAppDetails(this.price);

  factory QProductInAppDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductInAppDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$QProductInAppDetailsToJson(this);
}

