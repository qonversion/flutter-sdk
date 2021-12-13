import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'constants.dart';

Future<void> showNotification(RemoteMessage message) async {
  Map<String, dynamic> messageData = message.data;
  if (messageData != null && !kIsWeb) {
    String jsonMessageData = jsonEncode(messageData);

    FlutterLocalNotificationsPlugin().show(
        0, // notification id
        messageData["title"],
        messageData["body"],
        NotificationDetails(
          android: AndroidNotificationDetails(
            Constants.channelId,
            Constants.channelName,
            icon: 'launch_background',
          ),
        ),
        payload: jsonMessageData);
  }
}

/// This is called when user clicks on the notification
Future<void> onNotificationClick(Map <String, dynamic> messageData) async {
  print("onNotificationClick");
  if (messageData != null) {
    final isNotificationHandled = await Qonversion.handleNotification(messageData);
    if (!isNotificationHandled) {
      // Handle notification yourself
    }
  }
}