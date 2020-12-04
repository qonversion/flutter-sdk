import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/models/product_renew_state.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';

part 'permission.g.dart';

@JsonSerializable(createToJson: false)
class QPermission {
  /// Qonversion Permission ID, like premium.
  ///
  /// See [Create Permission](https://qonversion.io/docs/create-permission)
  @JsonKey(name: 'id')
  final String permissionId;

  /// Product ID created in Qonversion Dashboard.
  ///
  /// See [Create Products](https://qonversion.io/docs/create-products)
  @JsonKey(name: 'associated_product')
  final String productId;

  /// A renew state for an associate product that unlocked permission
  @JsonKey(
    name: 'renew_state',
    unknownEnumValue: QProductRenewState.unknown,
  )
  final QProductRenewState renewState;

  /// Purchase date
  @JsonKey(
    name: 'started_timestamp',
    fromJson: QMapper.dateTimeFromSecondsTimestamp,
  )
  final DateTime startedDate;

  /// Expiration date for subscription
  @JsonKey(
    name: 'expiration_timestamp',
    fromJson: QMapper.dateTimeFromSecondsTimestamp,
  )
  final DateTime expirationDate;

  /// Use for checking permission for current user.
  /// Pay attention, isActive == true does not mean that subscription is renewable.
  /// Subscription could be canceled, but the user could still have a permission
  @JsonKey(name: 'active')
  final bool isActive;

  const QPermission(
    this.permissionId,
    this.productId,
    this.renewState,
    this.startedDate,
    this.expirationDate,
    this.isActive,
  );

  factory QPermission.fromJson(Map<String, dynamic> json) =>
      _$QPermissionFromJson(json);
}
