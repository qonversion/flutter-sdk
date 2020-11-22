import 'package:json_annotation/json_annotation.dart';

import 'permission.dart';
import 'product.dart';

part 'launch_result.g.dart';

@JsonSerializable(createToJson: false)
class QLaunchResult {
  /// Qonversion User Identifier
  @JsonKey(name: 'uid')
  final String uid;

  /// Original Server response time
  @JsonKey(
    name: 'timestamp',
    fromJson: _dateTimeFromTimestamp,
  )
  final DateTime date;

  /// All products
  @JsonKey(
    name: 'products',
    fromJson: _productsFromJson,
  )
  final Map<String, QProduct> products;

  /// User permissions
  @JsonKey(
    name: 'permissions',
    fromJson: _permissionsFromJson,
  )
  final Map<String, QPermission> permissions;

  /// User products
  @JsonKey(
    name: 'user_products',
    fromJson: _productsFromJson,
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

Map<String, QProduct> _productsFromJson(dynamic json) {
  if (json == null) return <String, QProduct>{};

  final productsMap = Map<String, dynamic>.from(json);

  return productsMap.map((key, value) {
    final productMap = Map<String, dynamic>.from(value);
    return MapEntry(key, QProduct.fromJson(productMap));
  });
}

Map<String, QPermission> _permissionsFromJson(dynamic json) {
  if (json == null) return <String, QPermission>{};

  final permissionsMap = Map<String, dynamic>.from(json);

  return permissionsMap.map((key, value) {
    final permissionMap = Map<String, dynamic>.from(value);
    return MapEntry(key, QPermission.fromJson(permissionMap));
  });
}

DateTime _dateTimeFromTimestamp(int timestamp) =>
    DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).abs());
