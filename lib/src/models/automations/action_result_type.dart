import 'package:json_annotation/json_annotation.dart';

enum ActionResultType {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  url,
  @JsonValue(2)
  deepLink,
  @JsonValue(3)
  navigation,
  @JsonValue(4)
  purchase,
  @JsonValue(5)
  restore,
  @JsonValue(6)
  close,
}
