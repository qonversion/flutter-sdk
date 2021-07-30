import 'package:json_annotation/json_annotation.dart';
import '../constants.dart';
import 'product_duration.dart';
import 'product_type.dart';
import 'sk_product/sk_product_wrapper.dart';
import 'sku_details/sku_details.dart';
import 'sk_product/discount.dart';
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

  /// Store product ID.
  ///
  /// See [Create Products](https://qonversion.io/docs/create-products)
  @JsonKey(name: 'store_id')
  final String? storeId;

  /// Store product title
  @JsonKey(ignore: true)
  String? storeTitle;

  /// Store product description
  @JsonKey(ignore: true)
  String? storeDescription;

  /// Formatted localized price of the product, including its currency sign, such as €2.99
  @JsonKey(name: 'pretty_price')
  final String? prettyPrice;

  /// Localized price of the product
  @JsonKey(ignore: true)
  double? price;

  /// Formatted introductory price of a subscription, including its currency sign, such as €2.99
  @JsonKey(ignore: true)
  String? prettyIntroductoryPrice;

  /// Store Product currency code, such as USD
  @JsonKey(ignore: true)
  String? currencyCode;

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
  final QProductDuration? duration;

  /// Trial duration of the subscription
  @JsonKey(name: 'trial_duration')
  final QTrialDuration? trialDuration;

  /// Associated SKProduct.
  ///
  /// Available for iOS only.
  @JsonKey(name: 'sk_product', fromJson: QMapper.skProductFromJson)
  final SKProductWrapper? skProduct;

  /// Associated SkuDetails.
  ///
  /// Available for Android only.
  @JsonKey(name: 'sku_details', fromJson: QMapper.skuDetailsFromJson)
  final SkuDetailsWrapper? skuDetails;

  /// Associated Offering Id
  @JsonKey(name: 'offering_id')
  final String? offeringID;

  QProduct(
      this.qonversionId,
      this.storeId,
      this.type,
      this.duration,
      this.prettyPrice,
      this.trialDuration,
      this.skProduct,
      this.skuDetails,
      this.offeringID) {
    final skuDetails = this.skuDetails;
    final skProduct = this.skProduct;

    if(skuDetails != null) {
      storeTitle = skuDetails.title;
      storeDescription = skuDetails.description;
      currencyCode = skuDetails.priceCurrencyCode;
      // Returns the original price in micro-units, where 1000000 micro-units equal one unit of the currency
      price = skuDetails.priceAmountMicros / Constants.skuDetailsPriceRatio;

      final String? introPrice = skuDetails.introductoryPrice;
      if (introPrice != null && introPrice.isEmpty) {
        prettyIntroductoryPrice = null;
      } else {
        prettyIntroductoryPrice = introPrice;
      }
    }
    else if(skProduct != null) {
      storeTitle = skProduct.localizedTitle;
      storeDescription = skProduct.localizedDescription;
      currencyCode = skProduct.priceLocale?.currencyCode;
      price = double.tryParse(skProduct.price) ?? null;

      final SKProductDiscountWrapper? introPrice = skProduct.introductoryPrice;
      final String? currencySymbol = introPrice?.priceLocale?.currencySymbol;
      if (introPrice != null && currencySymbol != null) {
        prettyIntroductoryPrice = currencySymbol + introPrice.price;
      }
    }
  }

  factory QProduct.fromJson(Map<String, dynamic> json) =>
      _$QProductFromJson(json);

  Map<String, dynamic> toJson() => _$QProductToJson(this);
}
