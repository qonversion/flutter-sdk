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
  Map<String, QEntitlement> _entitlements;
  Map<String, QProduct> _products;

  StreamSubscription<String> _shownScreensStream;
  StreamSubscription<ActionResult> _startedActionsStream;
  StreamSubscription<ActionResult> _failedActionsStream;
  StreamSubscription<ActionResult> _finishedActionsStream;
  StreamSubscription<Null> _finishedAutomationsStream;

  @override
  void initState() {
    super.initState();
    _initPlatformState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message != null) {
        onNotificationClick(message?.data);
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        onNotificationClick(message?.data);
      }
    });

    _shownScreensStream = Automations.getSharedInstance().shownScreensStream.listen((event) {
      // do any logic you need
    });
    _startedActionsStream = Automations.getSharedInstance().startedActionsStream.listen((event) {
      // do any logic you need or track event
    });
    _failedActionsStream = Automations.getSharedInstance().failedActionsStream.listen((event) {
      // do any logic you need or track event
    });
    _finishedActionsStream = Automations.getSharedInstance().finishedActionsStream.listen((event) {
      if (event.type == ActionResultType.purchase) {
        // do any logic you need
      }
    });
    _finishedAutomationsStream =
        Automations.getSharedInstance().finishedAutomationsStream.listen((event) {
      // do any logic you need or track event
    });

    Automations.getSharedInstance().setScreenPresentationConfig(
        new QScreenPresentationConfig(QScreenPresentationStyle.push));
    Automations.getSharedInstance().setScreenPresentationConfig(
        new QScreenPresentationConfig(QScreenPresentationStyle.popover),
        "eQMi3E7V");
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
                    child: FlatButton(
                        child: Text('Set custom userId'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () => Automations.getSharedInstance().showScreen("RnJoXdez")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: FlatButton(
                      child: Text('Open ProductsView'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () =>
                          Automations.getSharedInstance().showScreen("eQMi3E7V"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: FlatButton(
                      child: Text('Open ParamsView'),
                      color: Colors.brown,
                      textColor: Colors.white,
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
                      child: FlatButton(
                        child: Text('Sync Purchases'),
                        color: Colors.orange,
                        textColor: Colors.white,
                        onPressed: () =>
                            Automations.getSharedInstance().setScreenPresentationConfig(
                                new QScreenPresentationConfig(
                                    QScreenPresentationStyle.noAnimation
                                ), "eQMi3E7V"
                            ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _initPlatformState() async {
    const environment = kDebugMode ? QEnvironment.sandbox : QEnvironment.production;
    final config = new QonversionConfigBuilder(
        'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2',
        QLaunchMode.subscriptionManagement
    )
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
    String deviceToken;
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
    return entitlements.entries
        .map<Widget>(
          (e) => ListTile(
            title: Text(e.key),
            subtitle: Text(
              e.value.productId ??
                  '' + '\n' + e.value.id ??
                  '' +
                      '\n' +
                      e.value.renewState.toString() +
                      '\n' +
                      (e.value.startedDate?.toString() ?? 'n/a') +
                      '\n' +
                      (e.value.expirationDate?.toString() ?? 'n/a') +
                      '\n' +
                      e.value.isActive.toString(),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _productsFromMap(Map<String, QProduct> products) {
    return products.entries
        .map<Widget>(
          (e) => ListTile(
            title: Text(e.key),
            subtitle: Text(
              e.value.qonversionId ??
                  '' + '\n' + e.value.storeId ??
                  '' +
                      '\n' +
                      e.value.duration.toString() +
                      '\n' +
                      e.value.type.toString() +
                      '\n',
            ),
          ),
        )
        .toList();
  }
}
