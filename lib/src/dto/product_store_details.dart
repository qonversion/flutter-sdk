import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

@JsonSerializable()
class QProductStoreDetails {
  /// Google product base plan ID
  @JsonKey(name: 'basePlanId')
  final String basePlanId;

  /// Product offer details
  @JsonKey(name: 'defaultOfferDetails')
  final ProductOfferDetails? defaultOfferDetails;

  /// Store product title
  @JsonKey(ignore: true)
  String description;

  /// Intro offer flag
  @JsonKey(ignore: true)
  bool hasIntroOffer;

  /// Trial offer flag
  @JsonKey(ignore: true)
  bool hasTrialOffer;

  /// Trial or intro offer flag
  @JsonKey(ignore: true)
  bool hasTrialOrIntroOffer;

  /// Product name
  @JsonKey(ignore: true)
  String name;

  /// Product ID
  @JsonKey(ignore: true)
  String productId;

  /// Product type
  @JsonKey(
      name: 'productType',
  unknownEnumValue: QProductType.unknown)
  final QProductType productType;

  /// Subscription offer details
  @JsonKey(ignore: true)
  ProductOfferDetails? subscriptionOfferDetails;

  /// Product title
  @JsonKey(ignore: true)
  String title;

  const QProductStoreDetails(
      this.basePlanId,
      this.defaultOfferDetails,
      this.description,
      this.hasIntroOffer,
      this.hasTrialOffer,
      this.hasTrialOrIntroOffer,
      this.name,
      this.productId,
      this.productType,
      this.subscriptionOfferDetails,
      this.title);

  factory QProductStoreDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductStoreDetails(json);

  Map<String, dynamic> toJson() => _$QProductStoreDetails(this);
}