import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:qonversion_flutter/src/internal/qonversion_internal.dart';
import '../dto/nocodes_events.dart';
import '../dto/presentation_config.dart';
import '../nocodes_config.dart';
import '../nocodes.dart';
import 'dart:convert';
import '../internal/constants.dart';

class NoCodesInternal implements NoCodes {
  final MethodChannel _channel = MethodChannel('qonversion_plugin');
  
  // Separate event channels for each event type
  final EventChannel _screenShownEventChannel = EventChannel('qonversion_flutter_nocodes_screen_shown');
  final EventChannel _finishedEventChannel = EventChannel('qonversion_flutter_nocodes_finished');
  final EventChannel _actionStartedEventChannel = EventChannel('qonversion_flutter_nocodes_action_started');
  final EventChannel _actionFailedEventChannel = EventChannel('qonversion_flutter_nocodes_action_failed');
  final EventChannel _actionFinishedEventChannel = EventChannel('qonversion_flutter_nocodes_action_finished');
  final EventChannel _screenFailedToLoadEventChannel = EventChannel('qonversion_flutter_nocodes_screen_failed_to_load');

  NoCodesInternal(NoCodesConfig config) {
    _initialize(config);
  }

  void _initialize(NoCodesConfig config) {
    // NoCodes is not supported on macOS
    if (Platform.isMacOS) {
      return;
    }

    final args = {
      Constants.kProjectKey: config.projectKey,
      Constants.kVersion: QonversionInternal.sdkVersion,
      Constants.kSource: Constants.sdkSource,
      if (config.proxyUrl != null) Constants.kProxyUrl: config.proxyUrl,
    };
    _channel.invokeMethod(Constants.mInitializeNoCodes, args);
  }

  @override
  Stream<NoCodesScreenShownEvent> get screenShownStream {
    if (Platform.isMacOS) {
      return Stream.empty();
    }
    return _screenShownEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) {
      final Map<String, dynamic> decodedEvent = jsonDecode(event);
      return NoCodesScreenShownEvent.fromMap(decodedEvent);
    });
  }

  @override
  Stream<NoCodesFinishedEvent> get finishedStream {
    if (Platform.isMacOS) {
      return Stream.empty();
    }
    return _finishedEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) {
      final Map<String, dynamic> decodedEvent = jsonDecode(event);
      return NoCodesFinishedEvent.fromMap(decodedEvent);
    });
  }

  @override
  Stream<NoCodesActionStartedEvent> get actionStartedStream {
    if (Platform.isMacOS) {
      return Stream.empty();
    }
    return _actionStartedEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) {
      final Map<String, dynamic> decodedEvent = jsonDecode(event);
      return NoCodesActionStartedEvent.fromMap(decodedEvent);
    });
  }

  @override
  Stream<NoCodesActionFailedEvent> get actionFailedStream {
    if (Platform.isMacOS) {
      return Stream.empty();
    }
    return _actionFailedEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) {
      final Map<String, dynamic> decodedEvent = jsonDecode(event);
      return NoCodesActionFailedEvent.fromMap(decodedEvent);
    });
  }

  @override
  Stream<NoCodesActionFinishedEvent> get actionFinishedStream {
    if (Platform.isMacOS) {
      return Stream.empty();
    }
    return _actionFinishedEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) {
      final Map<String, dynamic> decodedEvent = jsonDecode(event);
      return NoCodesActionFinishedEvent.fromMap(decodedEvent);
    });
  }

  @override
  Stream<NoCodesScreenFailedToLoadEvent> get screenFailedToLoadStream {
    if (Platform.isMacOS) {
      return Stream.empty();
    }
    return _screenFailedToLoadEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) {
      final Map<String, dynamic> decodedEvent = jsonDecode(event);
      return NoCodesScreenFailedToLoadEvent.fromMap(decodedEvent);
    });
  }

  @override
  Future<void> setScreenPresentationConfig(
    NoCodesPresentationConfig config, {
    String? contextKey,
  }) async {
    if (Platform.isMacOS) {
      return;
    }
    
    final args = {
      Constants.kConfig: config.toMap(),
      if (contextKey != null) Constants.kContextKey: contextKey,
    };
    await _channel.invokeMethod(Constants.mSetScreenPresentationConfig, args);
  }

  @override
  Future<void> showScreen(String contextKey) async {
    if (Platform.isMacOS) {
      return;
    }
    
    await _channel.invokeMethod(Constants.mShowNoCodesScreen, {Constants.kContextKey: contextKey});
  }

  @override
  Future<void> close() async {
    if (Platform.isMacOS) {
      return;
    }
    
    await _channel.invokeMethod(Constants.mCloseNoCodes);
  }
}