import 'package:json_annotation/json_annotation.dart';

enum QTransactionEnvironment {
  @JsonValue('Production')
  production,

  @JsonValue('Sandbox')
  sandbox,
}
