import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/purchase_update_policy.dart';
import 'package:qonversion_flutter/src/dto/store_product/product_offer_details.dart';
import 'package:qonversion_flutter/src/dto/store_product/product_store_details.dart';
import '../internal/constants.dart';
import 'product_type.dart';
import 'purchase_model.dart';
import 'purchase_update_model.dart';
import 'sk_product/sk_product_wrapper.dart';
import 'sku_details/sku_details.dart';
import 'sk_product/discount.dart';
import '../internal/mapper.dart';
import 'subscription_period.dart';
import '../qonversion.dart';

part 'product.g.dart';

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
  @JsonKey(name: 'storeId')
  final String? storeId;

  /// Identifier of the base plan for Google product.
  @JsonKey(name: 'basePlanId')
  final String? basePlanId;

  /// Google Play Store details of this product.
  /// Android only. Null for iOS, or if the product was not found.
  /// Doesn't take into account [basePlanId].
  /// @deprecated Consider using [storeDetails] instead.
  @JsonKey(name: 'skuDetails', fromJson: QMapper.skuDetailsFromJson)
  final SkuDetailsWrapper? skuDetails;

  /// Google Play Store details of this product.
  /// Android only. Null for iOS, or if the product was not found.
  @JsonKey(name: 'storeDetails', fromJson: QMapper.storeProductDetailsFromJson)
  final QProductStoreDetails? storeDetails;

  /// Associated SKProduct.
  ///
  /// Available for iOS only.
  @JsonKey(name: 'skProduct', fromJson: QMapper.skProductFromJson)
  final SKProductWrapper? skProduct;

  /// Associated Offering Id
  @JsonKey(name: 'offeringId')
  final String? offeringId;

  /// For Android - the subscription base plan duration. If the [basePlanId] is not specified,
  /// the duration is calculated using the deprecated [skuDetails].
  /// For iOS - the duration of the [skProduct].
  /// Null, if it's not a subscription product or the product was not found in the store.
  @JsonKey(name: 'subscriptionPeriod', fromJson: QMapper.subscriptionPeriodFromJson)
  final QSubscriptionPeriod? subscriptionPeriod;

  /// The subscription trial duration of the default offer for Android or of the product for iOS.
  /// See [QProductStoreDetails.defaultSubscriptionOfferDetails] for the information on how we
  /// choose the default offer for Android.
  /// Null, if it's not a subscription product or the product was not found the store.
  @JsonKey(name: 'trialPeriod', fromJson: QMapper.subscriptionPeriodFromJson)
  final QSubscriptionPeriod? trialPeriod;

  /// The calculated type of this product based on the store information.
  /// On Android uses deprecated [skuDetails] for the old subscription products
  /// where [basePlanId] is not specified, and [storeDetails] for all the other products.
  /// On iOS uses [skProduct] information.
  @JsonKey(name: 'type', unknownEnumValue: QProductType.unknown)
  final QProductType type;

  /// Formatted localized price of the product, including its currency sign, such as €2.99
  @JsonKey(name: 'prettyPrice')
  final String? prettyPrice;

  /// Localized price of the product
  @JsonKey(ignore: true)
  double? price;

  /// Store Product currency code, such as USD
  @JsonKey(ignore: true)
  String? currencyCode;

  /// Store product title
  @JsonKey(ignore: true)
  String? storeTitle;

  /// Store product description
  @JsonKey(ignore: true)
  String? storeDescription;

  /// Formatted introductory price of a subscription, including its currency sign, such as €2.99
  @JsonKey(ignore: true)
  String? prettyIntroductoryPrice;

  QProduct(
      this.qonversionId,
      this.storeId,
      this.basePlanId,
      this.skuDetails,
      this.storeDetails,
      this.skProduct,
      this.offeringId,
      this.subscriptionPeriod,
      this.trialPeriod,
      this.type,
      this.prettyPrice,
    ) {
    final skuDetails = this.skuDetails;
    final storeDetails = this.storeDetails;
    final skProduct = this.skProduct;

    if (skProduct != null) {
      storeTitle = skProduct.localizedTitle;
      storeDescription = skProduct.localizedDescription;
      currencyCode = skProduct.priceLocale?.currencyCode;
      price = double.tryParse(skProduct.price) ?? null;

      final SKProductDiscountWrapper? introPrice = skProduct.introductoryPrice;
      final String? currencySymbol = introPrice?.priceLocale?.currencySymbol;
      if (introPrice != null && currencySymbol != null) {
        prettyIntroductoryPrice = currencySymbol + introPrice.price;
      }
    } else {
      var priceMicros;
      if (skuDetails != null) {
        storeTitle = skuDetails.title;
        storeDescription = skuDetails.description;

        priceMicros = skuDetails.priceAmountMicros;
        currencyCode = skuDetails.priceCurrencyCode;

        final String? introPrice = skuDetails.introductoryPrice;
        if (introPrice != null && introPrice.isEmpty) {
          prettyIntroductoryPrice = null;
        } else {
          prettyIntroductoryPrice = introPrice;
        }
      }

      if (storeDetails != null) {
        storeTitle = storeDetails.title;
        storeDescription = storeDetails.description;

        final QProductOfferDetails? defaultOffer = storeDetails.defaultSubscriptionOfferDetails;
        if (defaultOffer != null) {
          priceMicros = defaultOffer.basePlan?.price.priceAmountMicros;
          currencyCode = defaultOffer.basePlan?.price.priceCurrencyCode;
          prettyIntroductoryPrice = defaultOffer.introPhase?.price.formattedPrice;
        }
      }

      price = priceMicros == null
          ? null
          : priceMicros / Constants.skuDetailsPriceRatio;
    }
  }

  /// Converts this product to purchase model to pass to [Qonversion.purchase].
  /// [offerId] concrete Android offer identifier if necessary.
  ///           If the products' base plan id is specified, but offer id is not provided for
  ///           purchase, then default offer will be used.
  ///           Ignored if base plan id is not specified.
  ///           Ignored for iOS.
  /// To know how we choose the default offer, see [QProductStoreDetails.defaultSubscriptionOfferDetails].
  /// Returns purchase model to pass to the purchase method.
  QPurchaseModel toPurchaseModel({String? offerId}) {
    return new QPurchaseModel(this.qonversionId, offerId: offerId);
  }

  /// Converts this product to purchase model to pass to [Qonversion.purchase].
  /// [offer] concrete Android offer which you'd like to purchase.
  /// Returns purchase model to pass to the purchase method.
  QPurchaseModel toPurchaseModelWithOffer(QProductOfferDetails offer) {
    final model = toPurchaseModel(offerId: offer.offerId);
    // Remove offer for the case when provided offer details are for bare base plan.
    if (offer.offerId == null) {
      model.removeOffer();
    }

    return model;
  }


  /// Android only.
  ///
  /// Converts this product to purchase update (upgrade/downgrade) model
  /// to pass to [Qonversion.updatePurchase].
  /// [oldProductId] Qonversion product identifier from which the upgrade/downgrade
  ///                will be initialized.
  /// [updatePolicy] purchase update policy.
  /// Returns purchase model to pass to the update purchase method.
  QPurchaseUpdateModel toPurchaseUpdateModel(
    String oldProductId,
    {QPurchaseUpdatePolicy? updatePolicy}
  ) {
    return new QPurchaseUpdateModel(this.qonversionId, oldProductId, updatePolicy: updatePolicy);
  }

  factory QProduct.fromJson(Map<String, dynamic> json) =>
      _$QProductFromJson(json);

  Map<String, dynamic> toJson() => _$QProductToJson(this);
}
