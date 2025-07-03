import 'dart:async';
import 'nocodes_events.dart';
import 'nocodes_config.dart';
import 'nocodes_internal.dart';
import 'presentation_config.dart';

/// Main No-Codes API class
/// 
/// **Platform Support:**
/// - ✅ iOS: Full support
/// - ✅ Android: Full support
/// - ❌ macOS: Not supported (returns empty streams and no-op methods)
abstract class NoCodes {
  static NoCodes? _backingInstance;

  /// Use this variable to get a current initialized instance of the No-Codes SDK.
  /// Please, use the property only after calling [NoCodes.initialize].
  /// Otherwise, trying to access the variable will cause an exception.
  ///
  /// Returns current initialized instance of the No-Codes SDK.
  /// Throws exception if the instance has not been initialized
  static NoCodes getSharedInstance() {
    NoCodes? instance = _backingInstance;

    if (instance == null) {
      throw new Exception("NoCodes has not been initialized. You should call " +
          "the initialize method before accessing the shared instance of NoCodes.");
    }

    return instance;
  }

  /// An entry point to use No-Codes SDK. Call to initialize No-Codes SDK with required config.
  /// The function is the best way to set additional configs you need to use No-Codes SDK.
  ///
  /// **Platform Support:** iOS and Android. On macOS, this will initialize but functionality will be limited.
  ///
  /// [config] a config that contains key SDK settings.
  /// Call [NoCodesConfigBuilder.build] to configure and create a [NoCodesConfig] instance.
  /// Returns initialized instance of the No-Codes SDK.
  static NoCodes initialize(NoCodesConfig config) {
    NoCodes instance = NoCodesInternal(config);
    _backingInstance = instance;
    return instance;
  }

  /// Initialize No-Codes with project key (for backward compatibility)
  /// 
  /// **Platform Support:** iOS and Android. On macOS, this will initialize but functionality will be limited.
  static Future<void> initializeWithProjectKey(String projectKey) async {
    final config = NoCodesConfig(projectKey);
    initialize(config);
  }

  /// Stream of screen shown events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty stream on macOS.
  Stream<NoCodesScreenShownEvent> get screenShownStream;

  /// Stream of finished events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty stream on macOS.
  Stream<NoCodesFinishedEvent> get finishedStream;

  /// Stream of action started events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty stream on macOS.
  Stream<NoCodesActionStartedEvent> get actionStartedStream;

  /// Stream of action failed events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty stream on macOS.
  Stream<NoCodesActionFailedEvent> get actionFailedStream;

  /// Stream of action finished events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty stream on macOS.
  Stream<NoCodesActionFinishedEvent> get actionFinishedStream;

  /// Stream of screen failed to load events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty stream on macOS.
  Stream<NoCodesScreenFailedToLoadEvent> get screenFailedToLoadStream;

  /// Set screen presentation configuration
  /// 
  /// **Platform Support:** iOS and Android. No-op on macOS.
  Future<void> setScreenPresentationConfig(
    NoCodesPresentationConfig config, {
    String? contextKey,
  });

  /// Show No-Codes screen with context key
  /// 
  /// **Platform Support:** iOS and Android. No-op on macOS.
  Future<void> showScreen(String contextKey);

  /// Close No-Codes screen
  /// 
  /// **Platform Support:** iOS and Android. No-op on macOS.
  Future<void> close();

  /// Get available events
  /// 
  /// **Platform Support:** iOS and Android. Returns empty list on macOS.
  Future<List<String>> getAvailableEvents();
} 