import 'package:json_annotation/json_annotation.dart';

enum QPermissionSource {
  @JsonValue("Unknown")
  unknown,

  @JsonValue("AppStore")
  appStore,

  @JsonValue("PlayStore")
  playStore,

  @JsonValue("Stripe")
  stripe,

  @JsonValue("Manual")
  manual,
}
