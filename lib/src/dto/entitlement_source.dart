import 'package:json_annotation/json_annotation.dart';

enum QEntitlementSource {
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
