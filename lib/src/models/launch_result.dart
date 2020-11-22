import 'package:json_annotation/json_annotation.dart';

import 'permission.dart';
import 'product.dart';

part 'launch_result.g.dart';

@JsonSerializable(createToJson: false)
class QLaunchResult {
  ///
  @JsonKey(name: 'uid')
  final String uid;

  ///
  @JsonKey(name: 'date')
  final DateTime date;

  ///
  @JsonKey(name: 'products', defaultValue: <String, QProduct>{})
  final Map<String, QProduct> products;

  ///
  @JsonKey(name: 'permissions', defaultValue: <String, QPermission>{})
  final Map<String, QPermission> permissions;

  ///
  @JsonKey(name: 'user_products', defaultValue: <String, QProduct>{})
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
