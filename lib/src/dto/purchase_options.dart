import 'package:qonversion_flutter/qonversion_flutter.dart';

/// Purchase options that may be used to modify purchase process.
/// To create an instance, use [QPurchaseOptionsBuilder] class.
class QPurchaseOptions {
  final String? offerId;
  final bool applyOffer;
  final QProduct? oldProduct;
  final QPurchaseUpdatePolicy? updatePolicy;
  final List<String>? contextKeys;
  final int quantity;
  final QPromotionalOffer? promotionalOffer;

  QPurchaseOptions(
      this.offerId,
      this.applyOffer,
      this.oldProduct,
      this.updatePolicy,
      this.contextKeys,
      this.quantity,
      this.promotionalOffer,
  );
}