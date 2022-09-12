import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class Automations {
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

  /// Called when Automations' screen is shown
  /// [screenId] shown screen Id
  static Stream<String> get shownScreensStream => _shownScreensEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        final Map<String, dynamic> decodedEvent = jsonDecode(event);
        return decodedEvent["screenId"];
      });

  /// Called when Automations flow starts executing an action
  /// [actionResult] action that is being executed
  static Stream<ActionResult> get startedActionsStream =>
      _startedActionsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        return _handleActionEvent(event);
      });

  /// Called when Automations flow fails executing an action
  /// [actionResult] failed action
  static Stream<ActionResult> get failedActionsStream =>
      _failedActionsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        return _handleActionEvent(event);
      });

  /// Called when Automations flow finishes executing an action
  /// [actionResult]  executed action.
  /// For instance, if the user made a purchase then action.type = ActionResultType.purchase.
  /// You can use the Qonversion.checkPermissions() method to get available permissions
  static Stream<ActionResult> get finishedActionsStream =>
      _finishedActionsEventChannel
          .receiveBroadcastStream()
          .cast<String>()
          .map((event) {
        return _handleActionEvent(event);
      });

  /// Called when Automations flow is finished and the Automations screen is closed
  static Stream<Null> get finishedAutomationsStream =>
      _finishedAutomationsEventChannel.receiveBroadcastStream().cast();

  static ActionResult _handleActionEvent(String event) {
    final Map<String, dynamic> decodedEvent = jsonDecode(event);

    return ActionResult.fromJson(decodedEvent);
  }
}
