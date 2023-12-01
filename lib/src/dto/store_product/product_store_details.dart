import 'package:json_annotation/json_annotation.dart';
import '../../internal/mapper.dart';
import '../product_type.dart';
import 'product_offer_details.dart';
import 'product_inapp_details.dart';

part 'product_store_details.g.dart';

/// This class contains all the information about the concrete Google product,
/// either subscription or in-app. In case of a subscription also determines concrete base plan.
@JsonSerializable()
class QProductStoreDetails {
  /// Identifier of the base plan to which these details relate.
  /// Null for in-app products.
  @JsonKey(name: 'basePlanId')
  final String? basePlanId;

  /// Identifier of a subscription or an in-app product.
  @JsonKey(name: 'productId')
  final String productId;

  /// Name of a subscription or an in-app product.
  @JsonKey(name: 'name')
  final String name;

  /// Title of a subscription or an in-app product.
  /// The title includes the name of the app.
  @JsonKey(name: 'title')
  final String title;

  /// Description of a subscription or an in-app product.
  @JsonKey(name: 'description')
  final String description;

  /// Offer details for a subscription.
  /// Offer details contain all the available variations of purchase offers,
  /// including both base plan and eligible base plan + offer combinations
  /// from Google Play Console for current [basePlanId].
  /// Null for in-app products.
  @JsonKey(name: 'subscriptionOfferDetails', fromJson: QMapper.productOfferDetailsListFromJson)
  final List<QProductOfferDetails>? subscriptionOfferDetails;

  /// The most profitable subscription offer for the client in our opinion from all the available offers.
  /// We calculate the cheapest price for the client by comparing all the trial or intro phases
  /// along with the base plan.
  @JsonKey(name: 'defaultSubscriptionOfferDetails', fromJson: QMapper.productOfferDetailsFromJson)
  final QProductOfferDetails? defaultSubscriptionOfferDetails;

  /// Subscription offer details containing only the base plan without any offer.
  @JsonKey(name: 'basePlanSubscriptionOfferDetails', fromJson: QMapper.productOfferDetailsFromJson)
  final QProductOfferDetails? basePlanSubscriptionOfferDetails;

  /// Offer details for an in-app product.
  /// Null for subscriptions.
  @JsonKey(name: 'inAppOfferDetails', fromJson: QMapper.productInAppDetailsFromJson)
  final QProductInAppDetails? inAppOfferDetails;

  /// True if there is any eligible offer with trial
  /// for this subscription and base plan combination.
  /// False otherwise or for an in-app product.
  @JsonKey(name: 'hasTrialOffer')
  final bool hasTrialOffer;

  /// True if there is any eligible offer with intro price
  /// for this subscription and base plan combination.
  /// False otherwise or for an in-app product.
  @JsonKey(name: 'hasIntroOffer')
  final bool hasIntroOffer;

  /// True if there is any eligible offer with trial or intro price
  /// for this subscription and base plan combination.
  /// False otherwise or for an in-app product.
  @JsonKey(name: 'hasTrialOrIntroOffer')
  final bool hasTrialOrIntroOffer;

  /// The calculated type of the current product.
  @JsonKey(name: 'productType', unknownEnumValue: QProductType.unknown)
  final QProductType productType;

  /// True if the product type is InApp.
  @JsonKey(name: 'isInApp')
  final bool isInApp;

  /// True if the product type is Subscription.
  @JsonKey(name: 'isSubscription')
  final bool isSubscription;

  const QProductStoreDetails(
      this.basePlanId,
      this.productId,
      this.name,
      this.title,
      this.description,
      this.subscriptionOfferDetails,
      this.defaultSubscriptionOfferDetails,
      this.basePlanSubscriptionOfferDetails,
      this.inAppOfferDetails,
      this.hasTrialOffer,
      this.hasIntroOffer,
      this.hasTrialOrIntroOffer,
      this.productType,
      this.isInApp,
      this.isSubscription,
  );

  factory QProductStoreDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductStoreDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$QProductStoreDetailsToJson(this);
}