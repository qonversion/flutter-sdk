import 'product.dart';
import 'purchase_update_policy.dart';
import 'purchase_options_builder.dart';

/// Purchase options that may be used to modify purchase process.
/// To create an instance, use [QPurchaseOptionsBuilder] class.
class QPurchaseOptions {
  final String? offerId;
  final bool applyOffer;
  final QProduct? oldProduct;
  final QPurchaseUpdatePolicy? updatePolicy;
  final List<String>? contextKeys;
  final int quantity;

  QPurchaseOptions(this.offerId, this.applyOffer, this.oldProduct, this.updatePolicy, this.contextKeys, this.quantity);
}