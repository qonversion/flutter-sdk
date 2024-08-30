import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'handling_notification.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, QEntitlement>? _entitlements = null;
  Map<String, QProduct>? _products = null;

  late StreamSubscription<String> _shownScreensStream;
  late StreamSubscription<ActionResult> _startedActionsStream;
  late StreamSubscription<ActionResult> _failedActionsStream;
  late StreamSubscription<ActionResult> _finishedActionsStream;
  late StreamSubscription<Null> _finishedAutomationsStream;

  @override
  void initState() {
    super.initState();
    _initPlatformState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        onNotificationClick(message.data);
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        onNotificationClick(message.data);
      }
    });

    _shownScreensStream =
        Automations.getSharedInstance().shownScreensStream.listen((event) {
      // do any logic you need
    });
    _startedActionsStream =
        Automations.getSharedInstance().startedActionsStream.listen((event) {
      // do any logic you need or track event
    });
    _failedActionsStream =
        Automations.getSharedInstance().failedActionsStream.listen((event) {
      // do any logic you need or track event
    });
    _finishedActionsStream =
        Automations.getSharedInstance().finishedActionsStream.listen((event) {
      if (event.type == ActionResultType.purchase) {
        // do any logic you need
      }
    });
    _finishedAutomationsStream = Automations.getSharedInstance()
        .finishedAutomationsStream
        .listen((event) {
      // do any logic you need or track event
    });
  }

  @override
  void dispose() {
    _shownScreensStream.cancel();
    _startedActionsStream.cancel();
    _failedActionsStream.cancel();
    _finishedActionsStream.cancel();
    _finishedAutomationsStream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qonversion example app'),
      ),
      body: Center(
        child: _products == null && _entitlements == null
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  ListTile(title: Text('PRODUCTS:')),
                  ..._productsFromMap(_products ?? {}),
                  ListTile(title: Text('PERMISSIONS:')),
                  ..._entitlementsFromMap(_entitlements ?? {}),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        child: Text('Set custom userId'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        onPressed: () => Qonversion.getSharedInstance()
                            .setUserProperty(
                                QUserPropertyKey.customUserId, 'userId')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: TextButton(
                      child: Text('Open ProductsView'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('products'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: TextButton(
                      child: Text('Open ParamsView'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.brown),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('params'),
                    ),
                  ),
                  if (Platform.isAndroid)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: TextButton(
                        child: Text('Sync Purchases'),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.orange),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        onPressed: () =>
                            Qonversion.getSharedInstance().syncPurchases(),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _initPlatformState() async {
    const environment =
        kDebugMode ? QEnvironment.sandbox : QEnvironment.production;
    final config = new QonversionConfigBuilder(
            'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2',
            QLaunchMode.subscriptionManagement)
        .setEnvironment(environment)
        .build();
    Qonversion.initialize(config);
    Qonversion.getSharedInstance().collectAppleSearchAdsAttribution();
    _sendNotificationsToken();
    _loadQonversionObjects();
  }

  Future<void> _loadQonversionObjects() async {
    try {
      _products = await Qonversion.getSharedInstance().products();
      _entitlements = await Qonversion.getSharedInstance().checkEntitlements();
    } catch (e) {
      print(e);
      _products = {};
      _entitlements = {};
    }

    setState(() {});
  }

  Future<void> _sendNotificationsToken() async {
    String? deviceToken;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        {
          deviceToken = await FirebaseMessaging.instance.getToken();
        }
        break;

      case TargetPlatform.iOS:
        {
          deviceToken = await FirebaseMessaging.instance.getAPNSToken();
        }
        break;
      default:
        deviceToken = null;
        break;
    }

    if (deviceToken != null) {
      Automations.getSharedInstance().setNotificationsToken(deviceToken);
      print('Device token: $deviceToken');
    }
  }

  List<Widget> _entitlementsFromMap(Map<String, QEntitlement> entitlements) {
    return entitlements.entries.map<Widget>((e) {
      var title = e.value.productId +
          '\n' + e.value.id +
          '\n' + e.value.renewState.toString() +
          '\n' + (e.value.startedDate?.toString() ?? 'n/a') +
          '\n' + (e.value.expirationDate?.toString() ?? 'n/a') +
          '\n' + e.value.isActive.toString();


      return ListTile(
        title: Text(e.key),
        subtitle: Text(title),
      );
    }).toList();
  }

  List<Widget> _productsFromMap(Map<String, QProduct> products) {
    return products.entries.map<Widget>((e) {
      var title = e.value.qonversionId;
      var storeId = e.value.storeId;
      var subscriptionPeriod = e.value.subscriptionPeriod;

      if (storeId != null) {
        title += '\n' + storeId;
      }
      if (subscriptionPeriod != null) {
        title += '\n' +
            subscriptionPeriod.unitCount.toString() +
            ' ' +
            subscriptionPeriod.unit.toString() +
            '\n' +
            e.value.type.toString();
      }

      return ListTile(
        title: Text(e.key),
        subtitle: Text(title),
      );
    }).toList();
  }
}
