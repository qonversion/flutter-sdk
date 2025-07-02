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
    final presentationStyleString = map['presentationStyle'] as String?;
    NoCodesPresentationStyle presentationStyle;
    
    switch (presentationStyleString) {
      case 'Push':
        presentationStyle = NoCodesPresentationStyle.push;
        break;
      case 'FullScreen':
        presentationStyle = NoCodesPresentationStyle.fullScreen;
        break;
      case 'Popover':
        presentationStyle = NoCodesPresentationStyle.popover;
        break;
      default:
        presentationStyle = NoCodesPresentationStyle.fullScreen;
    }

    return NoCodesPresentationConfig(
      animated: map['animated'] as bool? ?? true,
      presentationStyle: presentationStyle,
    );
  }

  Map<String, dynamic> toMap() {
    String presentationStyleString;
    switch (presentationStyle) {
      case NoCodesPresentationStyle.push:
        presentationStyleString = 'Push';
        break;
      case NoCodesPresentationStyle.fullScreen:
        presentationStyleString = 'FullScreen';
        break;
      case NoCodesPresentationStyle.popover:
        presentationStyleString = 'Popover';
        break;
    }

    return {
      'animated': animated,
      'presentationStyle': presentationStyleString,
    };
  }

  @override
  String toString() {
    return 'NoCodesPresentationConfig(animated: $animated, presentationStyle: $presentationStyle)';
  }
} 