import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'constants.dart';

class AutomationsInternal implements Automations {
  static const MethodChannel _channel = MethodChannel('qonversion_plugin');

  static const _shownScreensEventChannel =
      EventChannel('qonversion_flutter_shown_screens');
  static const _startedActionsEventChannel =
      EventChannel('qonversion_flutter_started_actions');
  static const _failedActionsEventChannel =
      EventChannel('qonversion_flutter_failed_actions');
  static const _finishedActionsEventChannel =
      EventChannel('qonversion_flutter_finished_actions');
  static const _finishedAutomationsEventChannel =
      EventChannel('qonversion_flutter_finished_automations');

  @override
  Stream<String> get shownScreensStream => _shownScreensEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        final Map<String, dynamic> decodedEvent = jsonDecode(event);
        return decodedEvent["screenId"];
      });

  @override
  Stream<ActionResult> get startedActionsStream =>
      _startedActionsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        return _handleActionEvent(event);
      });

  @override
  Stream<ActionResult> get failedActionsStream =>
      _failedActionsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        return _handleActionEvent(event);
      });

  @override
  Stream<ActionResult> get finishedActionsStream =>
      _finishedActionsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        return _handleActionEvent(event);
      });

  @override
  Stream<Null> get finishedAutomationsStream =>
      _finishedAutomationsEventChannel.receiveBroadcastStream().cast();

  @override
  Future<void> setNotificationsToken(String token) {
    return _channel.invokeMethod(Constants.mSetNotificationsToken,
        {Constants.kNotificationsToken: token});
  }

  @override
  Future<bool> handleNotification(Map<String, dynamic> notificationData) async {
    try {
      final bool rawResult = await _channel.invokeMethod(
          Constants.mHandleNotification,
          {Constants.kNotificationData: notificationData}) as bool;
      return rawResult;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getNotificationCustomPayload(Map<String, dynamic> notificationData) async {
    try {
      final String rawResult = await _channel.invokeMethod(
          Constants.mGetNotificationCustomPayload,
          {Constants.kNotificationData: notificationData}) as String;

      final Map<String, dynamic> result = jsonDecode(rawResult);
      return result;
    } catch (e) {
      return null;
    }
  }

  static ActionResult _handleActionEvent(String event) {
    final Map<String, dynamic> decodedEvent = jsonDecode(event);

    return ActionResult.fromJson(decodedEvent);
  }
}
