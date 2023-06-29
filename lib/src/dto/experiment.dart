import 'package:json_annotation/json_annotation.dart';

import 'experiment_group.dart';

part 'experiment.g.dart';

@JsonSerializable(createToJson: false)
class QExperiment {
  /// Experiment's identifier.
  @JsonKey(name: 'id')
  final String id;

  /// Experiment's name.
  @JsonKey(name: 'name')
  final String name;

  /// Experiment's group the user has been assigned to.
  @JsonKey(name: 'group')
  final QExperimentGroup group;

  const QExperiment(
      this.id,
      this.name,
      this.group,
      );

  factory QExperiment.fromJson(Map<String, dynamic> json) =>
      _$QExperimentFromJson(json);
}
