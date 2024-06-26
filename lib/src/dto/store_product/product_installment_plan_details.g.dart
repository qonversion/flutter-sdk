// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_installment_plan_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QProductInstallmentPlanDetails _$QProductInstallmentPlanDetailsFromJson(
    Map<String, dynamic> json) {
  return QProductInstallmentPlanDetails(
    json['commitmentPaymentsCount'] as int,
    json['subsequentCommitmentPaymentsCount'] as int,
  );
}

Map<String, dynamic> _$QProductInstallmentPlanDetailsToJson(
        QProductInstallmentPlanDetails instance) =>
    <String, dynamic>{
      'commitmentPaymentsCount': instance.commitmentPaymentsCount,
      'subsequentCommitmentPaymentsCount':
          instance.subsequentCommitmentPaymentsCount,
    };
