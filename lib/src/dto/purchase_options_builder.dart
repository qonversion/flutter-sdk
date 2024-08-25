import '../qonversion.dart';
import 'product.dart';
import 'purchase_options.dart';
import 'purchase_update_policy.dart';
import 'store_product/product_offer_details.dart';
import 'store_product/product_store_details.dart';

class QPurchaseOptionsBuilder {
  String? _offerId;
  bool _applyOffer = true;
  QProduct? _oldProduct;
  QPurchaseUpdatePolicy? _updatePolicy;
  List<String>? _contextKeys;
  int _quantity = 1;

  /// Android only.
  /// Set the offer to the purchase.
  /// If [offer] is not specified, then the default offer will be applied. To know how we choose
  /// the default offer, see [QProductStoreDetails.defaultSubscriptionOfferDetails].
  ///
  /// [offer] concrete offer which you'd like to purchase.
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder setOffer(QProductOfferDetails offer) {
    _offerId = offer.offerId;
    return this;
  }

  /// Android only.
  /// Set the offer Id to the purchase.
  /// If [offerId] is not specified, then the default offer will be applied. To know how we choose
  /// the default offer, see [QProductStoreDetails.defaultSubscriptionOfferDetails].
  ///
  /// [offerId] concrete offer Id which you'd like to purchase.
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder setOfferId(String offerId) {
    _offerId = offerId;
    return this;
  }

  /// Android only.
  /// Call this function to remove any intro/trial offer from the purchase (use only a bare base plan).
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder removeOffer() {
    _applyOffer = false;
    return this;
  }

  /// Android only.
  /// Set Qonversion product from which the upgrade/downgrade
  /// will be initialized.
  ///
  /// [oldProduct] Qonversion product from which the upgrade/downgrade
  /// will be initialized.
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder setOldProduct(QProduct oldProduct) {
    _oldProduct = oldProduct;
    return this;
  }

  /// Android only.
  /// Set the update policy for the purchase.
  /// If the [updatePolicy] is not provided, then default one
  /// will be selected - [QPurchaseUpdatePolicy.withTimeProration].
  /// [updatePolicy] update policy for the purchase.
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder setUpdatePolicy(QPurchaseUpdatePolicy updatePolicy) {
    _updatePolicy = updatePolicy;
    return this;
  }

  /// Set the context keys associated with a purchase.
  ///
  /// [contextKeys] context keys for the purchase.
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder setContextKeys(List<String> contextKeys) {
    _contextKeys = contextKeys;
    return this;
  }

  /// iOS only.
  /// Set quantity of product purchasing. Use for consumable in-app products.
  ///
  /// [quantity] quantity of product purchasing.
  /// Returns builder instance for chain calls.
  QPurchaseOptionsBuilder setQuantity(int quantity) {
    _quantity = quantity;
    return this;
  }

  /// Generate [QPurchaseOptions] instance with all the provided options.
  ///
  /// Returns the complete [QPurchaseOptions] instance.
  QPurchaseOptions build() {
    return QPurchaseOptions(_offerId, _applyOffer, _oldProduct, _updatePolicy, _contextKeys, _quantity);
  }

}