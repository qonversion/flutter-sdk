import 'package:json_annotation/json_annotation.dart';

enum QProductType {
  /// Provides access to content on a recurring basis with a free trial offer
  @JsonValue('Trial')
  trial,

  /// Provides access to content on a recurring basis with an introductory price offer
  @JsonValue('Intro')
  intro,

  /// Provides access to content on a recurring basis
  @JsonValue('Subscription')
  subscription,

  /// Content that users can purchase with a single, non-recurring charge
  @JsonValue('InApp')
  inApp,

  @JsonValue('Unknown')
  unknown,
}
