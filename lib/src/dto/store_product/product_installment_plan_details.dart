import 'package:json_annotation/json_annotation.dart';

part 'product_installment_plan_details.g.dart';

/// This class represents the details about the installment plan for a subscription product.
@JsonSerializable()
class QProductInstallmentPlanDetails {
  /// Committed payments count after a user signs up for this subscription plan.
  @JsonKey(name: 'commitmentPaymentsCount')
  final int commitmentPaymentsCount;

  /// Subsequent committed payments count after this subscription plan renews.
  ///
  /// Returns 0 if the installment plan doesn't have any subsequent commitment,
  /// which means this subscription plan will fall back to a normal
  /// non-installment monthly plan when the plan renews.
  @JsonKey(name: 'subsequentCommitmentPaymentsCount')
  final int subsequentCommitmentPaymentsCount;

  const QProductInstallmentPlanDetails(
      this.commitmentPaymentsCount,
      this.subsequentCommitmentPaymentsCount
  );

  factory QProductInstallmentPlanDetails.fromJson(Map<String, dynamic> json) =>
      _$QProductInstallmentPlanDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$QProductInstallmentPlanDetailsToJson(this);
}