import 'package:json_annotation/json_annotation.dart';

import 'experiment_group_type.dart';

part 'experiment_group.g.dart';

@JsonSerializable(createToJson: false)
class QExperimentGroup {
  /// Experiment group's identifier.
  @JsonKey(name: 'id')
  final String id;

  /// Experiment group's name. The same as you set in Qonversion. You can use it for analytical purposes.
  @JsonKey(name: 'name')
  final String name;

  /// Type of the experiment's group. Either control or treatment.
  @JsonKey(
    name: 'type',
    unknownEnumValue: QExperimentGroupType.unknown,
  )
  final QExperimentGroupType type;

  const QExperimentGroup(
      this.id,
      this.name,
      this.type,
      );

  factory QExperimentGroup.fromJson(Map<String, dynamic> json) =>
      _$QExperimentGroupFromJson(json);
}
