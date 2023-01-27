import 'package:json_annotation/json_annotation.dart';
import 'screen_presentation_style.dart';

part 'screen_presentation_config.g.dart';

@JsonSerializable()
class QScreenPresentationConfig {
  /// Describes how screens will be displayed.
  /// For mode details see the enum description.
  final QScreenPresentationStyle presentationStyle;

  /// iOS only. Ignored on Android.
  /// Describes whether should transaction be animated or not.
  /// Default value is true.
  @JsonKey(toJson: animatedToJson)
  final bool animated;

  QScreenPresentationConfig(this.presentationStyle, [this.animated = true]);

  Map<String, dynamic> toJson() => _$QScreenPresentationConfigToJson(this);
}

String animatedToJson(bool animated) {
  return animated ? '1' : '0';
}