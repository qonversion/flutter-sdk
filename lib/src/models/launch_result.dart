import 'package:json_annotation/json_annotation.dart';

import 'permission.dart';
import 'product.dart';
import 'utils/mapper.dart';

part 'launch_result.g.dart';

@JsonSerializable(createToJson: false)
class QLaunchResult {
  /// Qonversion User Identifier
  @JsonKey(name: 'uid')
  final String uid;

  /// Original Server response time
  @JsonKey(
    name: 'timestamp',
    fromJson: QMapper.dateTimeFromTimestamp,
  )
  final DateTime date;

  /// All products
  @JsonKey(
    name: 'products',
    fromJson: QMapper.productsFromJson,
  )
  final Map<String, QProduct> products;

  /// User permissions
  @JsonKey(
    name: 'permissions',
    fromJson: QMapper.permissionsFromJson,
  )
  final Map<String, QPermission> permissions;

  /// User products
  @JsonKey(
    name: 'user_products',
    fromJson: QMapper.productsFromJson,
  )
  final Map<String, QProduct> userProducts;

  const QLaunchResult(
    this.uid,
    this.date,
    this.products,
    this.permissions,
    this.userProducts,
  );

  factory QLaunchResult.fromJson(Map<String, dynamic> json) =>
      _$QLaunchResultFromJson(json);
}
