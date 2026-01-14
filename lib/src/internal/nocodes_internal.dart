import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:qonversion_flutter/src/dto/qonversion_exception.dart';
import 'package:qonversion_flutter/src/internal/qonversion_internal.dart';
import '../dto/nocodes_events.dart';
import '../dto/presentation_config.dart';
import '../dto/product.dart';
import '../nocodes_config.dart';
import '../nocodes.dart';
import '../nocodes_purchase_delegate.dart';
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
  
  // Event channels for purchase delegate
  final EventChannel _purchaseEventChannel = EventChannel('qonversion_flutter_nocodes_purchase');
  final EventChannel _restoreEventChannel = EventChannel('qonversion_flutter_nocodes_restore');

  NoCodesPurchaseDelegate? _purchaseDelegate;
  StreamSubscription? _purchaseSubscription;
  StreamSubscription? _restoreSubscription;

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
      if (config.locale != null) Constants.kLocale: config.locale,
    };
    // Initialize is fire-and-forget, errors will be handled in subsequent calls
    _channel.invokeMethod(Constants.mInitializeNoCodes, args).catchError((error) {
      developer.log(
        'Failed to initialize NoCodes: $error',
        name: 'QonversionFlutter',
        error: error,
      );
    });

    // Set purchase delegate if provided in config
    if (config.purchaseDelegate != null) {
      setPurchaseDelegate(config.purchaseDelegate!);
    }
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
    await _invokeMethod(Constants.mSetScreenPresentationConfig, args);
  }

  @override
  Future<void> showScreen(String contextKey) async {
    if (Platform.isMacOS) {
      return;
    }
    
    await _invokeMethod(Constants.mShowNoCodesScreen, {Constants.kContextKey: contextKey});
  }

  @override
  Future<void> close() async {
    if (Platform.isMacOS) {
      return;
    }
    
    await _invokeMethod(Constants.mCloseNoCodes);
  }

  @override
  Future<void> setLocale(String? locale) async {
    if (Platform.isMacOS) {
      return;
    }
    
    await _invokeMethod(Constants.mSetNoCodesLocale, {Constants.kLocale: locale});
  }

  @override
  Future<void> setPurchaseDelegate(NoCodesPurchaseDelegate delegate) async {
    if (Platform.isMacOS) {
      return;
    }

    _purchaseDelegate = delegate;

    // Subscribe to purchase events from native
    _purchaseSubscription?.cancel();
    _purchaseSubscription = _purchaseEventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .listen(_handlePurchaseEvent);

    // Subscribe to restore events from native
    _restoreSubscription?.cancel();
    _restoreSubscription = _restoreEventChannel
        .receiveBroadcastStream()
        .listen((_) => _handleRestoreEvent());

    // Notify native side that purchase delegate is set
    await _invokeMethod(Constants.mSetNoCodesPurchaseDelegate);
  }

  void _handlePurchaseEvent(String productJson) async {
    if (_purchaseDelegate == null) {
      developer.log(
        'PurchaseDelegate is not set but purchase event received',
        name: 'QonversionFlutter',
      );
      await _invokeMethod(Constants.mDelegatedPurchaseFailed, {
        Constants.kErrorMessage: 'PurchaseDelegate is not set',
      });
      return;
    }

    try {
      final Map<String, dynamic> productData = jsonDecode(productJson);
      final product = QProduct.fromJson(productData);
      
      await _purchaseDelegate!.purchase(product);
      await _invokeMethod(Constants.mDelegatedPurchaseCompleted);
    } catch (e) {
      developer.log(
        'Purchase delegate failed: $e',
        name: 'QonversionFlutter',
        error: e,
      );
      await _invokeMethod(Constants.mDelegatedPurchaseFailed, {
        Constants.kErrorMessage: e.toString(),
      });
    }
  }

  void _handleRestoreEvent() async {
    if (_purchaseDelegate == null) {
      developer.log(
        'PurchaseDelegate is not set but restore event received',
        name: 'QonversionFlutter',
      );
      await _invokeMethod(Constants.mDelegatedRestoreFailed, {
        Constants.kErrorMessage: 'PurchaseDelegate is not set',
      });
      return;
    }

    try {
      await _purchaseDelegate!.restore();
      await _invokeMethod(Constants.mDelegatedRestoreCompleted);
    } catch (e) {
      developer.log(
        'Restore delegate failed: $e',
        name: 'QonversionFlutter',
        error: e,
      );
      await _invokeMethod(Constants.mDelegatedRestoreFailed, {
        Constants.kErrorMessage: e.toString(),
      });
    }
  }

  /// Invokes a method on the platform channel and converts PlatformException to QonversionException
  Future<dynamic> _invokeMethod(String method, [Map<String, dynamic>? arguments]) async {
    try {
      return await _channel.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      throw QonversionException(
        e.code,
        e.message ?? "",
        e.details,
      );
    }
  }
}
