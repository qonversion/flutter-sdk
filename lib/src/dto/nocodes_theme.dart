/// Theme mode for No-Code screens.
/// Use this to control how screens adapt to light/dark themes.
enum NoCodesTheme {
  /// Automatically follow the device's system appearance (default).
  /// The screen will use light theme in light mode and dark theme in dark mode.
  auto,

  /// Force light theme regardless of device settings.
  light,

  /// Force dark theme regardless of device settings.
  dark,
}
