import '../qonversion.dart';
import 'product.dart';
import './store_product/product_store_details.dart';
import 'purchase_update_policy.dart';

/// Used to provide all the necessary purchase data to the [Qonversion.updatePurchase] method.
/// Can be created manually or using the [QProduct.toPurchaseUpdateModel] method.
///
/// Requires Qonversion product identifiers - [productId] for the purchasing one and
/// [oldProductId] for the purchased one.
///
/// If [offerId] is not specified for Android, then the default offer will be applied.
/// To know how we choose the default offer, see [QProductStoreDetails.defaultSubscriptionOfferDetails].
///
/// If you want to remove any intro/trial offer from the purchase on Android (use only a bare base plan),
/// call the [removeOffer] method.
class QPurchaseUpdateModel {

  final String productId;
  final String oldProductId;

  QPurchaseUpdatePolicy? updatePolicy;
  String? offerId;
  bool applyOffer = true;

  QPurchaseUpdateModel(
      this.productId,
      this.oldProductId,
      {this.updatePolicy, this.offerId}
  );

  QPurchaseUpdateModel removeOffer() {
    this.applyOffer = false;
    return this;
  }
}
