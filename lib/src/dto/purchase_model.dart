import '../qonversion.dart';
import 'product.dart';
import './store_product/product_store_details.dart';

/// Used to provide all the necessary purchase data to the [Qonversion.purchase] method.
/// Can be created manually or using the [QProduct.toPurchaseModel] method.
///
/// If [offerId] is not specified for Android, then the default offer will be applied.
/// To know how we choose the default offer, see [QProductStoreDetails.defaultSubscriptionOfferDetails].
///
/// If you want to remove any intro/trial offer from the purchase on Android (use only bare base plan),
/// call the [removeOffer] method.
class QPurchaseModel {

  final String productId;
  String? offerId;
  bool applyOffer = true;

  QPurchaseModel(this.productId, {this.offerId});

  QPurchaseModel removeOffer() {
    this.applyOffer = false;
    return this;
  }
}
