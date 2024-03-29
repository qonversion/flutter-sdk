import 'package:json_annotation/json_annotation.dart';

import 'experiment.dart';
import 'remote_configuration_source.dart';

part 'remote_config.g.dart';

@JsonSerializable(createToJson: false)
class QRemoteConfig {
  /// JSON payload you have configured using the Qonversion dashboard.
  @JsonKey(name: 'payload')
  final Map<String, dynamic> payload;

  /// Object with the experiment's information.
  @JsonKey(name: 'experiment')
  final QExperiment? experiment;

  @JsonKey(name: 'source')
  final QRemoteConfigurationSource source;

  const QRemoteConfig(
      this.payload,
      this.experiment,
      this.source
  );

  factory QRemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$QRemoteConfigFromJson(json);
}
