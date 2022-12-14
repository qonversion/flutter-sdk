import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'constants.dart';

class AutomationsInternal implements Automations {
  final MethodChannel _channel = MethodChannel('qonversion_plugin');

  final _shownScreensEventChannel =
      EventChannel('qonversion_flutter_shown_screens');
  final _startedActionsEventChannel =
      EventChannel('qonversion_flutter_started_actions');
  final _failedActionsEventChannel =
      EventChannel('qonversion_flutter_failed_actions');
  final _finishedActionsEventChannel =
      EventChannel('qonversion_flutter_finished_actions');
  final _finishedAutomationsEventChannel =
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

  AutomationsInternal() {
    _channel.invokeMethod(Constants.mSubscribeAutomations);
  }

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
      final String? rawResult = await _channel.invokeMethod(
          Constants.mGetNotificationCustomPayload,
          {Constants.kNotificationData: notificationData}) as String?;

      final Map<String, dynamic>? result = rawResult == null ? null : jsonDecode(rawResult);
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> showScreen(String screenId) {
    return _channel.invokeMethod(Constants.mShowScreen,
        {Constants.kScreenId: screenId});
  }

  static ActionResult _handleActionEvent(String event) {
    final Map<String, dynamic> decodedEvent = jsonDecode(event);

    return ActionResult.fromJson(decodedEvent);
  }
}
