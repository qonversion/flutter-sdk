import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

part 'user_properties.g.dart';

@JsonSerializable(createToJson: false)
class QUserProperties {
  /// List of all user properties.
  @JsonKey(name: "properties")
  final List<QUserProperty> properties;

  /// List of user properties, set for the Qonversion defined keys.
  /// This is a subset of all [properties] list.
  /// See [Qonversion.setUserProperty].
  final List<QUserProperty> definedProperties;

  /// List of user properties, set for custom keys.
  /// This is a subset of all [properties] list.
  /// See [Qonversion.setCustomUserProperty].
  final List<QUserProperty> customProperties;

  /// Map of all user properties.
  /// This is a flattened version of the [properties] list as a key-value map.
  final Map<String, String> flatPropertiesMap;

  /// Map of user properties, set for the Qonversion defined keys.
  /// This is a flattened version of the [definedProperties] list as a key-value map.
  /// See [Qonversion.setUserProperty].
  final Map<QUserPropertyKey, String> flatDefinedPropertiesMap;

  /// Map of user properties, set for custom keys.
  /// This is a flattened version of the [customProperties] list as a key-value map.
  /// See [Qonversion.setCustomUserProperty].
  final Map<String, String> flatCustomPropertiesMap;

  QUserProperties._(
    this.properties,
    this.definedProperties,
    this.customProperties,
    this.flatPropertiesMap,
    this.flatDefinedPropertiesMap,
    this.flatCustomPropertiesMap,
  );

  factory QUserProperties(List<QUserProperty> properties) {
    final List<QUserProperty> definedProperties = properties.whereNot(
            (userProperty) => userProperty.definedKey == QUserPropertyKey.custom
    ).toList();
    final List<QUserProperty> customProperties = properties.where(
            (userProperty) => userProperty.definedKey == QUserPropertyKey.custom
    ).toList();

    final Map<String, String> flatPropertiesMap = Map.fromIterable(
      properties,
      key: (userProperty) => userProperty.key,
      value: (userProperty) => userProperty.value,
    );

    final Map<QUserPropertyKey, String> flatDefinedPropertiesMap = Map.fromIterable(
      definedProperties,
      key: (userProperty) => userProperty.definedKey,
      value: (userProperty) => userProperty.value,
    );

    final Map<String, String> flatCustomPropertiesMap = Map.fromIterable(
      customProperties,
      key: (userProperty) => userProperty.key,
      value: (userProperty) => userProperty.value,
    );

    return QUserProperties._(
      properties,
      definedProperties,
      customProperties,
      flatPropertiesMap,
      flatDefinedPropertiesMap,
      flatCustomPropertiesMap,
    );
  }

  factory QUserProperties.fromJson(Map<String, dynamic> json) =>
      _$QUserPropertiesFromJson(json);

  /// Searches for a property with the given property [key] in all properties list.
  QUserProperty? getProperty(String key) {
    return properties.firstWhereOrNull((userProperty) => userProperty.key == key);
  }

  /// Searches for a property with the given Qonversion defined property [key]
  /// in defined properties list.
  QUserProperty? getDefinedProperty(QUserPropertyKey key) {
    return definedProperties.firstWhereOrNull((userProperty) => userProperty.definedKey == key);
  }
}
