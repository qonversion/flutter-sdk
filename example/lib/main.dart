import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  QLaunchResult _qLaunchResult;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Qonversion example app'),
        ),
        body: Center(
          child: _qLaunchResult == null
              ? CircularProgressIndicator()
              : ListView(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    ListTile(
                      title: Text('UID'),
                      subtitle: Text(_qLaunchResult.uid),
                    ),
                    ListTile(
                      title: Text('DateTime'),
                      subtitle: Text(_qLaunchResult.date.toString()),
                    ),
                    ListTile(title: Text('PRODUCTS:')),
                    ..._productsFromMap(_qLaunchResult.products),
                    ListTile(title: Text('PERMISSIONS:')),
                    ..._permissionsFromMap(_qLaunchResult.permissions),
                    ListTile(title: Text('USER PRODUCTS:')),
                    ..._productsFromMap(_qLaunchResult.userProducts),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text('Set custom userId'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () => Qonversion.setUserId('userId'),
                      ),
                    ),
                    if (Platform.isAndroid)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }

  Future<void> initPlatformState() async {
    _qLaunchResult = await Qonversion.launch(
      'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2',
      isObserveMode: true,
    );

    setState(() {});
  }

  List<Widget> _productsFromMap(Map<String, QProduct> products) {
    return products.entries
        .map<Widget>(
          (e) => ListTile(
            title: Text(e.key),
            subtitle: Text(
              e.value.qonversionId +
                  '\n' +
                  e.value.storeId +
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

  List<Widget> _permissionsFromMap(Map<String, QPermission> permissions) {
    return permissions.entries
        .map<Widget>(
          (e) => ListTile(
            title: Text(e.key),
            subtitle: Text(
              e.value.productId +
                  '\n' +
                  e.value.permissionId +
                  '\n' +
                  e.value.renewState.toString() +
                  '\n' +
                  e.value.startedDate.toString() +
                  '\n' +
                  e.value.expirationDate?.toString() +
                  '\n' +
                  e.value.isActive.toString(),
            ),
          ),
        )
        .toList();
  }
}
