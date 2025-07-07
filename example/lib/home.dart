import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, QEntitlement>? _entitlements = null;
  Map<String, QProduct>? _products = null;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: TextButton(
                      child: Text('Open NoCodesView'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.purple),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('nocodes'),
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
    const projectKey = 'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2';
    
    final config = new QonversionConfigBuilder(
            projectKey,
            QLaunchMode.subscriptionManagement)
        .setEnvironment(environment)
        .build();
    Qonversion.initialize(config);
    Qonversion.getSharedInstance().collectAppleSearchAdsAttribution();

    // Initialize NoCodes with the same project key using config builder
    final noCodesConfig = new NoCodesConfigBuilder(projectKey).build();
    NoCodes.initialize(noCodesConfig);
    
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
