import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

enum QScreenPresentationStyle {
  /// on Android - default screen transaction animation will be used.
  /// on iOS - not a modal presentation. This style pushes a controller to a current navigation stack.
  /// For iOS NavigationController on the top of the stack is required.
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
  /// For iOS consider providing the [QScreenPresentationConfig.animated] flag.
  @JsonValue('NoAnimation')
  noAnimation,
}
