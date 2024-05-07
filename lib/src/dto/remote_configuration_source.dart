import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/remote_configuration_assignment_type.dart';
import 'remote_configuration_source_type.dart';

part 'remote_configuration_source.g.dart';

@JsonSerializable(createToJson: false)
class QRemoteConfigurationSource {
  /// Source's identifier.
  @JsonKey(name: 'id')
  final String id;

  /// Source's name.
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(
    name: 'type',
    unknownEnumValue: QRemoteConfigurationSourceType.unknown,
  )
  final QRemoteConfigurationSourceType type;

  @JsonKey(
    name: 'assignmentType',
    unknownEnumValue: QRemoteConfigurationAssignmentType.unknown,
  )
  final QRemoteConfigurationAssignmentType assignmentType;

  @JsonKey(name: 'contextKey')
  final String? contextKey;

  const QRemoteConfigurationSource(
      this.id,
      this.name,
      this.type,
      this.assignmentType,
      this.contextKey,
  );

  factory QRemoteConfigurationSource.fromJson(Map<String, dynamic> json) =>
      _$QRemoteConfigurationSourceFromJson(json);
}
