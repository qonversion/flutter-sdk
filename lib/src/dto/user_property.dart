import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/user_property_key.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

part 'user_property.g.dart';

@JsonSerializable(createToJson: false)
class QUserProperty {
  @JsonKey(name: "key")
  final String key;

  @JsonKey(name: "value")
  final String value;

  final QUserPropertyKey definedKey;

  QUserProperty._(this.key, this.value, this.definedKey);

  factory QUserProperty(String key, String value) {
    final calculatedKey = QMapper.userPropertyKeyFromString(key);
    return QUserProperty._(key, value, calculatedKey);
  }

  factory QUserProperty.fromJson(Map<String, dynamic> json) =>
      _$QUserPropertyFromJson(json);
}
