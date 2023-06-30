import 'package:json_annotation/json_annotation.dart';

enum QExperimentGroupType {
  /// Unknown group
  @JsonValue('unknown')
  unknown,

  /// Treatment group
  @JsonValue('treatment')
  treatment,

  /// Control group
  @JsonValue('control')
  control,
}
