import 'package:json_annotation/json_annotation.dart';

enum QEnvironment {
  @JsonValue("Sandbox")
  sandbox,

  @JsonValue("Production")
  production,
}
