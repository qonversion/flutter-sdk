import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  QLaunchResult _qLaunchResult;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    subtitle: Text(_qLaunchResult.date?.toString() ?? 'n/a'),
                  ),
                  ListTile(title: Text('PRODUCTS:')),
                  ...productsFromMap(_qLaunchResult.products),
                  ListTile(title: Text('PERMISSIONS:')),
                  ..._permissionsFromMap(_qLaunchResult.permissions),
                  ListTile(title: Text('USER PRODUCTS:')),
                  ...productsFromMap(_qLaunchResult.userProducts),
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

  Future<void> initPlatformState() async {
    _qLaunchResult = await Qonversion.launch(
      'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2',
      isObserveMode: false,
    );

    setState(() {});
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
}

List<Widget> productsFromMap(Map<String, QProduct> products) {
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
