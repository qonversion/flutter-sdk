import 'package:json_annotation/json_annotation.dart';

enum ActionResultType {
  @JsonValue('unknown')
  unknown,
  @JsonValue('url')
  url,
  @JsonValue('deeplink')
  deepLink,
  @JsonValue('navigate')
  navigation,
  @JsonValue('purchase')
  purchase,
  @JsonValue('restore')
  restore,
  @JsonValue('close')
  close,
}
