import 'package:json_annotation/json_annotation.dart';

enum QScreenPresentationStyle {
  /// on Android - default screen transaction animation will be used.
  /// on iOS - not a modal presentation. This style pushes a controller to a current navigation stack.
  @JsonValue('Push')
  push,

  /// on Android - screen will move from bottom to top.
  /// on iOS - UIModalPresentationFullScreen analog.
  @JsonValue('FullScreen')
  fullScreen,

  /// iOS only - UIModalPresentationPopover analog
  @JsonValue('Popover')
  popover,

  /// Android only - screen will appear/disappear without any animation
  @JsonValue('NoAnimation')
  noAnimation,
}
