import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/product_pricing_phase.dart';

@JsonSerializable()
class QProductOfferDetails {
  /// Google product base plan ID
  @JsonKey(name: 'basePlanId')
  final String basePlanId;

  /// Intro flag
  @JsonKey(ignore: true)
  bool hasIntro;

  /// Trial flag
  @JsonKey(ignore: true)
  bool hasTrial;

  /// Trial or intro flag
  @JsonKey(ignore: true)
  bool hasTrialOrIntro;

  /// Intro phase details
  @JsonKey(ignore: true)
  QProductPricingPhase introPhase;

  /// Pricing phases details
  @JsonKey(ignore: true)
  List<QProductPricingPhase> pricingPhases;

  /// Offer ID
  @JsonKey(ignore: true)
  String offerId;

  /// Offer token
  @JsonKey(ignore: true)
  String offerToken;

  /// Offer tags
  @JsonKey(ignore: true)
  List<String> tags;

  /// Offer token
  @JsonKey(ignore: true)
  QProductPricingPhase? trialPhase;

  const QProductOfferDetails(
      this.basePlanId,
      this.hasIntro,
      this.hasTrial,
      this.hasTrialOrIntro,
      this.introPhase,
      this.pricingPhases,
      this.offerId,
      this.offerToken,
      this.tags,
      this.trialPhase);

  factory QProductOfferDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductOfferDetails(json);

  Map<String, dynamic> toJson() => _$QProductOfferDetails(this);
}