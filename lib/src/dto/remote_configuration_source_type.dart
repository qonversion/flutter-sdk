import 'package:json_annotation/json_annotation.dart';

enum QRemoteConfigurationSourceType {
  /// Unknown source type
  @JsonValue('unknown')
  unknown,

  /// Treatment group
  @JsonValue('experiment_treatment_group')
  experimentTreatmentGroup,

  /// Control group
  @JsonValue('experiment_control_group')
  experimentControlGroup,

  /// Remote configuration
  @JsonValue('remote_configuration')
  remoteConfiguration,
}
