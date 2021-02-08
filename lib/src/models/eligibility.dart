import 'package:json_annotation/json_annotation.dart';

part 'eligibility.g.dart';

enum QEligibilityStatus {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  nonIntroProduct,
  @JsonValue(2)
  ineligible,
  @JsonValue(3)
  eligible,
}

@JsonSerializable()
class QEligibility {
  @JsonKey(name: "status", defaultValue: QEligibilityStatus.unknown)
  final QEligibilityStatus status;

  const QEligibility(this.status);

  factory QEligibility.fromJson(Map<String, dynamic> json) =>
      _$QEligibilityFromJson(json);
}
