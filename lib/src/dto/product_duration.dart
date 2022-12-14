import 'package:json_annotation/json_annotation.dart';

enum QProductDuration {
  @JsonValue(0)
  weekly,
  @JsonValue(1)
  monthly,
  @JsonValue(2)
  threeMonths,
  @JsonValue(3)
  sixMonths,
  @JsonValue(4)
  annual,
  @JsonValue(5)
  lifetime,
  unknown,
}
