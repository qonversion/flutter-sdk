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
  Map<String, QPermission> _permissions;
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

    _shownScreensStream = Automations.shownScreensStream.listen((event) {
      // do any logic you need
    });
    _startedActionsStream = Automations.startedActionsStream.listen((event) {
      // do any logic you need or track event
    });
    _failedActionsStream = Automations.failedActionsStream.listen((event) {
      // do any logic you need or track event
    });
    _finishedActionsStream = Automations.finishedActionsStream.listen((event) {
      if (event.type == ActionResultType.purchase) {
        // do any logic you need
      }
    });
    _finishedAutomationsStream =
        Automations.finishedAutomationsStream.listen((event) {
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
        child: _products == null && _permissions == null
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  ListTile(title: Text('PRODUCTS:')),
                  ..._productsFromMap(_products ?? {}),
                  ListTile(title: Text('PERMISSIONS:')),
                  ..._permissionsFromMap(_permissions ?? {}),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text('Set custom userId'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () => Qonversion.setUserId('userId'),
                    ),
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
                          Navigator.of(context).pushNamed('products'),
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
                        onPressed: () => Qonversion.syncPurchases(),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _initPlatformState() async {
    if (kDebugMode) {
      Qonversion.setDebugMode();
    }

    Qonversion.launch(
      'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2',
      isObserveMode: false,
    );

    Qonversion.setAppleSearchAdsAttributionEnabled(true);
    _sendNotificationsToken();
    _loadQonversionObjects();
  }

  Future<void> _loadQonversionObjects() async {
    try {
      _products = await Qonversion.products();
      _permissions = await Qonversion.checkPermissions();
    } catch (e) {
      print(e);
      _products = {};
      _permissions = {};
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

    Qonversion.setNotificationsToken(deviceToken);
    print('Device token: $deviceToken');
  }

  List<Widget> _permissionsFromMap(Map<String, QPermission> permissions) {
    return permissions.entries
        .map<Widget>(
          (e) => ListTile(
            title: Text(e.key),
            subtitle: Text(
              e.value.productId ??
                  '' + '\n' + e.value.permissionId ??
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
