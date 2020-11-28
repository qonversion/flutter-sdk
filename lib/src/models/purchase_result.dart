import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'utils/mapper.dart';

part 'purchase_result.g.dart';

@JsonSerializable(createToJson: false)
class QPurchaseResult {
  /// Map with user's permissions.
  ///
  /// Permissions IDs are the keys to the dictionary.
  @JsonKey(name: 'permissions', fromJson: QMapper.permissionsFromJson)
  final Map<String, QPermission> permissions;

  /// iOS only.
  ///
  /// `true` if user explicitly cancelled the purchasing process.
  @JsonKey(name: 'is_cancelled')
  final bool isCancelled;

  const QPurchaseResult(
    this.permissions,
    this.isCancelled,
  );

  factory QPurchaseResult.fromJson(Map<String, dynamic> json) =>
      _$QPurchaseResultFromJson(json);
}
