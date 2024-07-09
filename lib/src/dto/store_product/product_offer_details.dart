import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/store_product/product_installment_plan_details.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

import './product_pricing_phase.dart';

part 'product_offer_details.g.dart';

/// This class contains all the information about the Google subscription offer details.
/// It might be either a plain base plan details or a base plan with the concrete offer details.
@JsonSerializable()
class QProductOfferDetails {
  /// The identifier of the current base plan.
  @JsonKey(name: 'basePlanId')
  final String basePlanId;

  /// The identifier of the concrete offer, to which these details belong.
  /// Null, if these are plain base plan details.
  @JsonKey(name: 'offerId')
  final String? offerId;

  /// A token to purchase the current offer.
  @JsonKey(name: 'offerToken')
  final String offerToken;

  /// List of tags set for the current offer.
  @JsonKey(name: 'tags')
  final List<String> tags;

  /// A time-ordered list of pricing phases for the current offer.
  @JsonKey(name: 'pricingPhases', fromJson: QMapper.productPricingPhaseListFromJson)
  final List<QProductPricingPhase> pricingPhases;

  /// A base plan phase details.
  @JsonKey(name: 'basePlan', fromJson: QMapper.productPricingPhaseFromJson)
  final QProductPricingPhase? basePlan;

  /// Additional details of an installment plan, if exists.
  @JsonKey(name: 'installmentPlanDetails', fromJson: QMapper.productInstallmentPlanDetailsFromJson)
  final QProductInstallmentPlanDetails? installmentPlanDetails;

  /// A trial phase details, if exists.
  @JsonKey(name: 'introPhase', fromJson: QMapper.productPricingPhaseFromJson)
  final QProductPricingPhase? introPhase;

  /// The intro phase details, if exists.
  /// Intro phase is one of single or recurrent discounted payments.
  @JsonKey(name: 'trialPhase', fromJson: QMapper.productPricingPhaseFromJson)
  final QProductPricingPhase? trialPhase;

  /// True, if there is a trial phase in the current offer. False otherwise.
  @JsonKey(name: 'hasTrial')
  final bool hasTrial;

  /// True, if there is any intro phase in the current offer. False otherwise.
  /// The intro phase is one of single or recurrent discounted payments.
  @JsonKey(name: 'hasIntro')
  final bool hasIntro;

  /// True, if there is any trial or intro phase in the current offer. False otherwise.
  /// The intro phase is one of single or recurrent discounted payments.
  @JsonKey(name: 'hasTrialOrIntro')
  final bool hasTrialOrIntro;

  const QProductOfferDetails(
      this.basePlanId,
      this.offerId,
      this.offerToken,
      this.tags,
      this.pricingPhases,
      this.basePlan,
      this.installmentPlanDetails,
      this.introPhase,
      this.trialPhase,
      this.hasTrial,
      this.hasIntro,
      this.hasTrialOrIntro,
  );

  factory QProductOfferDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductOfferDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$QProductOfferDetailsToJson(this);
}