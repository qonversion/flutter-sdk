import 'package:json_annotation/json_annotation.dart';

import 'product_duration.dart';
import 'product_type.dart';
import 'sk_product/sk_product_wrapper.dart';
import 'sku_details/sku_details.dart';
import 'utils/mapper.dart';

part 'product.g.dart';

enum QTrialDuration {
  @JsonValue(-1)
  notAvailable,
  @JsonValue(1)
  threeDays,
  @JsonValue(2)
  week,
  @JsonValue(3)
  twoWeeks,
  @JsonValue(4)
  month,
  @JsonValue(5)
  twoMonths,
  @JsonValue(6)
  threeMonths,
  @JsonValue(7)
  sixMonths,
  @JsonValue(8)
  year,
  @JsonValue(9)
  other,
}

@JsonSerializable()
class QProduct {
  /// Product ID created in Qonversion Dashboard.
  ///
  /// See [Create Products](https://qonversion.io/docs/create-products)
  @JsonKey(name: 'id')
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

  /// Localized price, e.g. 4.99 USD
  @JsonKey(name: 'pretty_price')
  final String prettyPrice;

  /// Trial duration of the subscription
  @JsonKey(name: 'trial_duration')
  final QTrialDuration trialDuration;

  /// Associated SKProduct.
  ///
  /// Available for iOS only.
  @JsonKey(name: 'sk_product', fromJson: QMapper.skProductFromJson)
  final SKProductWrapper skProduct;

  /// Associated SkuDetails.
  ///
  /// Available for Android only.
  @JsonKey(name: 'sku_details', fromJson: QMapper.skuDetailsFromJson)
  final SkuDetailsWrapper skuDetails;

  const QProduct(
    this.qonversionId,
    this.storeId,
    this.type,
    this.duration,
    this.prettyPrice,
    this.trialDuration,
    this.skProduct,
    this.skuDetails,
  );

  factory QProduct.fromJson(Map<String, dynamic> json) =>
      _$QProductFromJson(json);

  Map<String, dynamic> toJson() => _$QProductToJson(this);
}
