import 'package:json_annotation/json_annotation.dart';

enum QProductType {
  /// Provides access to content on a recurring basis with a free introductory offer
  @JsonValue(0)
  trial,

  /// Provides access to content on a recurring basis
  @JsonValue(1)
  subscription,

  /// Content that users can purchase with a single, non-recurring charge
  @JsonValue(2)
  inApp,
  unknown,
}
