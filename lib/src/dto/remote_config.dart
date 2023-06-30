import 'package:json_annotation/json_annotation.dart';

import 'experiment.dart';

part 'remote_config.g.dart';

@JsonSerializable(createToJson: false)
class QRemoteConfig {
  /// JSON payload you have configured using the Qonversion dashboard.
  @JsonKey(name: 'payload')
  final Map<String, dynamic> payload;

  /// Object with the experiment's information.
  @JsonKey(name: 'experiment')
  final QExperiment? experiment;

  const QRemoteConfig(
      this.payload,
      this.experiment,
      );

  factory QRemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$QRemoteConfigFromJson(json);
}
