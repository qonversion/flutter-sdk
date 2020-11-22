import 'package:json_annotation/json_annotation.dart';

import 'product_duration.dart';
import 'product_type.dart';

part 'product.g.dart';

@JsonSerializable(createToJson: false)
class QProduct {
  /// Product ID created in Qonversion Dashboard.
  ///
  /// See [Create Products](https://qonversion.io/docs/create-products)
  @JsonKey(name: 'q_id')
  final String qonversionId;

  /// Apple Store Product ID.
  ///
  /// See [Create Products](https://qonversion.io/docs/create-products)
  @JsonKey(name: 'store_id')
  final String storeId;

  /// Product type.
  ///
  /// See [Products types](https://qonversion.io/docs/product-types)
  @JsonKey(
    name: 'type',
    unknownEnumValue: QProductType.unknown,
  )
  final QProductType type;

  /// Product duration.
  ///
  /// See [Products durations](https://qonversion.io/docs/product-durations)
  @JsonKey(
    name: 'duration',
    unknownEnumValue: QProductDuration.unknown,
  )
  final QProductDuration duration;

  const QProduct(
    this.qonversionId,
    this.storeId,
    this.type,
    this.duration,
  );

  factory QProduct.fromJson(Map<String, dynamic> json) =>
      _$QProductFromJson(json);
}
