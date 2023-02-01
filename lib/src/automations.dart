import 'dart:ffi';

import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/internal/automations_internal.dart';

abstract class Automations {
  static Automations? _backingInstance;

  /// Use this variable to get a current initialized instance of the Qonversion Automations.
  /// Please, use Automations only after calling [Qonversion.initialize].
  /// Otherwise, trying to access the variable will cause an exception.
  ///
  /// Returns current initialized instance of the Qonversion Automations.
  /// Throws [Exception] if Qonversion has not been initialized.
  static Automations getSharedInstance() {
    Automations? instance = _backingInstance;

    if (instance == null) {
      try {
        Qonversion.getSharedInstance();
      } catch (e) {
        throw new Exception("Qonversion has not been initialized. " +
            "Automations should be used after Qonversion is initialized.");
      }

      instance = new AutomationsInternal();
      _backingInstance = instance;
    }

    return instance;
  }

  /// Called when Automations' screen is shown
  /// [screenId] shown screen Id
  Stream<String> get shownScreensStream;

  /// Called when Automations flow starts executing an action
  /// [actionResult] action that is being executed
  Stream<ActionResult> get startedActionsStream;

  /// Called when Automations flow fails executing an action
  /// [actionResult] failed action
  Stream<ActionResult> get failedActionsStream;

  /// Called when Automations flow finishes executing an action
  /// [actionResult]  executed action.
  /// For instance, if the user made a purchase then action.type = ActionResultType.purchase.
  /// You can use the [Qonversion.checkEntitlements] method to get available entitlements.
  Stream<ActionResult> get finishedActionsStream;

  /// Called when Automations flow is finished and the Automations screen is closed
  Stream<Null> get finishedAutomationsStream;

  /// Set push token to Qonversion to enable Qonversion push notifications
  /// [token] Firebase device token for Android. APNs device token for iOS
  Future<void> setNotificationsToken(String token);

  /// [notificationData] notification payload data
  /// See [Firebase RemoteMessage data](https://pub.dev/documentation/firebase_messaging_platform_interface/latest/firebase_messaging_platform_interface/RemoteMessage/data.html)
  /// See [APNs notification data](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649869-userinfo)
  /// Returns true when a push notification was received from Qonversion. Otherwise returns false, so you need to handle the notification yourself
  Future<bool> handleNotification(Map<String, dynamic> notificationData);

  /// Get parsed custom payload, which you added to the notification in the dashboard
  /// [notificationData] notification payload data
  /// See [Firebase RemoteMessage data](https://pub.dev/documentation/firebase_messaging_platform_interface/latest/firebase_messaging_platform_interface/RemoteMessage/data.html)
  /// See [APNs notification data](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649869-userinfo)
  /// Returns a map with custom payload from the notification or null if it's not provided.
  Future<Map<String, dynamic>?> getNotificationCustomPayload(Map<String, dynamic> notificationData);

  /// Show the screen using its ID.
  /// [screenId] Identifier of the screen which must be shown
  Future<void> showScreen(String screenId);

  /// Set the configuration of screen representation.
  /// [config] a configuration to apply.
  /// [screenId] identifier of screen, to which a config should be applied.
  ///            If not provided, the config is used for all the screens.
  Future<void> setScreenPresentationConfig(QScreenPresentationConfig config, [String? screenId]);
}
