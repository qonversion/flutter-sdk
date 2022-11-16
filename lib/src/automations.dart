import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qonversion_flutter/src/internal/automations_internal.dart';

abstract class Automations {
  static Automations? _backingInstance;

  /// Use this variable to get a current initialized instance of the Qonversion SDK.
  /// Please, use the property only after calling {@link Automations.initialize}.
  /// Otherwise, trying to access the variable will cause an exception.
  ///
  /// Returns current initialized instance of the Automations SDK.
  /// Throws [Exception] if the instance has not been initialized.
  static Automations getSharedInstance() {
    Automations? instance = _backingInstance;

    if (instance == null) {
      throw new Exception("Automations have not been initialized. You should call " +
          "the initialize method before accessing the shared instance of Automations.");
    }

    return instance;
  }

  /// An entry point to use Qonversion Automations. Call to initialize Automations.
  /// Make sure you have initialized [Qonversion] first.
  ///
  /// Returns initialized instance of the Automations SDK.
  /// Throws [Exception] if [Qonversion] has not been initialized.
  static Automations initialize() {
    try {
      Qonversion.getSharedInstance();
    } catch (e) {
      throw new Exception("Qonversion has not been initialized. " +
          "Automations initialization should be called after Qonversion is initialized.");
    }

    final instance = new AutomationsInternal();
    _backingInstance = instance;
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
  /// [token] Firebase device token on Android. APNs device token on iOS
  Future<void> setNotificationsToken(String token);

  /// [notificationData] notification payload data
  /// See [Firebase RemoteMessage data](https://pub.dev/documentation/firebase_messaging_platform_interface/latest/firebase_messaging_platform_interface/RemoteMessage/data.html)
  /// See [APNs notification data](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649869-userinfo)
  /// Returns true when a push notification was received from Qonversion. Otherwise returns false, so you need to handle a notification yourself
  Future<bool> handleNotification(Map<String, dynamic> notificationData);

  /// Get parsed custom payload, which you added to the notification in the dashboard
  /// [notificationData] notification payload data
  /// See [Firebase RemoteMessage data](https://pub.dev/documentation/firebase_messaging_platform_interface/latest/firebase_messaging_platform_interface/RemoteMessage/data.html)
  /// See [APNs notification data](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649869-userinfo)
  /// Returns a map with custom payload from the notification or null if it's not provided.
  Future<Map<String, dynamic>?> getNotificationCustomPayload(Map<String, dynamic> notificationData);
}
