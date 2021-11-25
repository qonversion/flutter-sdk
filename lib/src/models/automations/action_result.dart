import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/models/qonversion_error.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';
import 'action_result_type.dart';

part 'action_result.g.dart';

@JsonSerializable()
class ActionResult {
  @JsonKey(name: "action_type", defaultValue: ActionResultType.unknown)
  final ActionResultType type;

  @JsonKey(name: "parameters")
  final Map<String, String>? parameters;

  @JsonKey(
    name: "error",
    fromJson: QMapper.qonversionErrorFromJson,
  )
  final QError? error;

  const ActionResult(this.type, this.parameters, this.error);

  factory ActionResult.fromJson(Map<String, dynamic> json) =>
      _$ActionResultFromJson(json);

  Map<String, dynamic> toJson() => _$ActionResultToJson(this);
}
