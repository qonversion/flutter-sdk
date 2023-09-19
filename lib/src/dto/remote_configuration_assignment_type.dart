import 'package:json_annotation/json_annotation.dart';

enum QRemoteConfigurationAssignmentType {
  /// Unknown assignment type
  @JsonValue('unknown')
  unknown,

  /// Auto
  @JsonValue('auto')
  auto,

  /// Manual
  @JsonValue('manual')
  manual,
}
