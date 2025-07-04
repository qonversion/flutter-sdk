static const kPush = 'Push';
static const kFullScreen = 'FullScreen';
static const kPopover = 'Popover';
static const kAnimated = 'animated';
static const kPresentationStyle = 'presentationStyle';

/// Presentation style for NoCodes screens
enum NoCodesPresentationStyle {
  push,
  fullScreen,
  popover,
}

/// Configuration for NoCodes screen presentation
class NoCodesPresentationConfig {
  final bool animated;
  final NoCodesPresentationStyle presentationStyle;

  const NoCodesPresentationConfig({
    this.animated = true,
    this.presentationStyle = NoCodesPresentationStyle.fullScreen,
  });

  factory NoCodesPresentationConfig.fromMap(Map<String, dynamic> map) {
    final presentationStyleString = map[kPresentationStyle] as String?;
    NoCodesPresentationStyle presentationStyle;
    
    switch (presentationStyleString) {
      case kPush:
        presentationStyle = NoCodesPresentationStyle.push;
        break;
      case kFullScreen:
        presentationStyle = NoCodesPresentationStyle.fullScreen;
        break;
      case kPopover:
        presentationStyle = NoCodesPresentationStyle.popover;
        break;
      default:
        presentationStyle = NoCodesPresentationStyle.fullScreen;
    }

    return NoCodesPresentationConfig(
      animated: map[kAnimated] as bool? ?? true,
      presentationStyle: presentationStyle,
    );
  }

  Map<String, dynamic> toMap() {
    String presentationStyleString;
    switch (presentationStyle) {
      case NoCodesPresentationStyle.push:
        presentationStyleString = kPush;
        break;
      case NoCodesPresentationStyle.fullScreen:
        presentationStyleString = kFullScreen;
        break;
      case NoCodesPresentationStyle.popover:
        presentationStyleString = kPopover;
        break;
    }

    return {
      kAnimated: animated,
      kPresentationStyle: presentationStyleString,
    };
  }

  @override
  String toString() {
    return 'NoCodesPresentationConfig(animated: $animated, presentationStyle: $presentationStyle)';
  }
} 