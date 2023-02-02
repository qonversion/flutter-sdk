import 'package:json_annotation/json_annotation.dart';

part 'eligibility.g.dart';

enum QEligibilityStatus {
  @JsonValue('unknown')
  unknown,
  @JsonValue('non_intro_or_trial_product')
  nonIntroProduct,
  @JsonValue('intro_or_trial_ineligible')
  ineligible,
  @JsonValue('intro_or_trial_eligible')
  eligible,
}

@JsonSerializable(createToJson: false)
class QEligibility {
  @JsonKey(name: "status", defaultValue: QEligibilityStatus.unknown)
  final QEligibilityStatus status;

  const QEligibility(this.status);

  factory QEligibility.fromJson(Map<String, dynamic> json) =>
      _$QEligibilityFromJson(json);
}
