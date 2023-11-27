import 'package:json_annotation/json_annotation.dart';

enum QProductPeriodUnit {
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

@JsonSerializable()
class QProductPeriod {
  /// Product period count
  @JsonKey(ignore: true)
  int count;

  /// Product period iso
  @JsonKey(ignore: true)
  String iso;

  /// Product period unit
  @JsonKey(ignore: true)
  QProductPeriodUnit unit;

  const QProductPeriod(
      this.count,
      this.iso,
      this.unit);

  factory QProductPeriod.fromJson(Map<String, dynamic> json) =>
      _$QProductPeriod(json);

  Map<String, dynamic> toJson() => _$QProductPeriod(this);
}