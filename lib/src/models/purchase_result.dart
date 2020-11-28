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

  /// Optional error.
  ///
  /// If exists, something went wrong with purchasing an item.
  ///
  /// If doesn't exist, everything's fine and you're free to check `permissions` Map.
  @JsonKey(name: 'error')
  final String error;

  /// iOS only.
  ///
  /// `true` if user explicitly canceled the purchasing process.
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
