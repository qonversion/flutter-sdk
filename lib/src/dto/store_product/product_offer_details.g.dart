// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_offer_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductOfferDetails _$QProductOfferDetailsFromJson(Map<String, dynamic> json) {
  return QProductOfferDetails(
    json['basePlanId'] as String,
    json['offerId'] as String?,
    json['offerToken'] as String,
    (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    QMapper.productPricingPhaseListFromJson(json['pricingPhases']),
    QMapper.productPricingPhaseFromJson(json['basePlan']),
    QMapper.productInstallmentPlanDetailsFromJson(
        json['installmentPlanDetails']),
    QMapper.productPricingPhaseFromJson(json['introPhase']),
    QMapper.productPricingPhaseFromJson(json['trialPhase']),
    json['hasTrial'] as bool,
    json['hasIntro'] as bool,
    json['hasTrialOrIntro'] as bool,
  );
}

Map<String, dynamic> _$QProductOfferDetailsToJson(
        QProductOfferDetails instance) =>
    <String, dynamic>{
      'basePlanId': instance.basePlanId,
      'offerId': instance.offerId,
      'offerToken': instance.offerToken,
      'tags': instance.tags,
      'pricingPhases': instance.pricingPhases,
      'basePlan': instance.basePlan,
      'installmentPlanDetails': instance.installmentPlanDetails,
      'introPhase': instance.introPhase,
      'trialPhase': instance.trialPhase,
      'hasTrial': instance.hasTrial,
      'hasIntro': instance.hasIntro,
      'hasTrialOrIntro': instance.hasTrialOrIntro,
    };
