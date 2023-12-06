import 'package:json_annotation/json_annotation.dart';

part 'subscription_period.g.dart';

enum QSubscriptionPeriodUnit {
  @JsonValue("Day")
  day,
  @JsonValue("Week")
  week,
  @JsonValue("Month")
  month,
  @JsonValue("Year")
  year,
  @JsonValue("Unknown")
  unknown,
}

/// A class describing a subscription period
@JsonSerializable()
class QSubscriptionPeriod {
  /// A count of subsequent intervals.
  @JsonKey(name: 'unitCount')
  final int unitCount;

  /// Interval unit.
  @JsonKey(name: 'unit', unknownEnumValue: QSubscriptionPeriodUnit.unknown)
  final QSubscriptionPeriodUnit unit;

  /// ISO 8601 representation of the period, e.g. "P7D", meaning 7 days period.
  @JsonKey(name: 'iso')
  final String iso;

  const QSubscriptionPeriod(
      this.unitCount,
      this.unit,
      this.iso,
  );

  factory QSubscriptionPeriod.fromJson(Map<String, dynamic> json) =>
      _$QSubscriptionPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$QSubscriptionPeriodToJson(this);
}