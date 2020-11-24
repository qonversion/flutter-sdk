import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'utils/mapper.dart';

part 'purchase_result.g.dart';

@JsonSerializable(createToJson: false)
class QPurchaseResult {
  @JsonKey(name: 'permissions', fromJson: QMapper.permissionsFromJson)
  final Map<String, QPermission> permissions;

  @JsonKey(name: 'error')
  final String error;

  @JsonKey(name: 'is_cancelled')
  final bool isCancelled;

  const QPurchaseResult(
    this.permissions,
    this.error,
    this.isCancelled,
  );

  factory QPurchaseResult.fromJson(Map<String, dynamic> json) =>
      _$QPurchaseResultFromJson(json);
}
