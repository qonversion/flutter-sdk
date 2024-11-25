// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QEligibility _$QEligibilityFromJson(Map<String, dynamic> json) => QEligibility(
      $enumDecodeNullable(_$QEligibilityStatusEnumMap, json['status']) ??
          QEligibilityStatus.unknown,
    );

const _$QEligibilityStatusEnumMap = {
  QEligibilityStatus.unknown: 'unknown',
  QEligibilityStatus.nonIntroOrTrialProduct: 'non_intro_or_trial_product',
  QEligibilityStatus.ineligible: 'intro_or_trial_ineligible',
  QEligibilityStatus.eligible: 'intro_or_trial_eligible',
};
