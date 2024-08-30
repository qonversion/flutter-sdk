import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  var _products = <QProduct>[];
  QOfferings? _offerings = null;
  late StreamSubscription<Map<String, QEntitlement>> _updatedEntitlementsStream;
  late StreamSubscription<String> _promoPurchasesStream;

  @override
  void initState() {
    super.initState();
    _loadOfferings();

    _updatedEntitlementsStream =
        Qonversion.getSharedInstance().updatedEntitlementsStream.listen((event) => print(event));

    _promoPurchasesStream =
        Qonversion.getSharedInstance().promoPurchasesStream.listen((promoPurchaseId) async {
      try {
        final entitlements = await Qonversion.getSharedInstance().promoPurchase(promoPurchaseId);
        // Get Qonversion product by App Store ID
        final QProduct? qProduct = _products.firstWhereOrNull((element) => element.storeId == promoPurchaseId);
        // Get entitlement by Qonversion product
        final entitlement = entitlements?.values.firstWhereOrNull((element) => element.productId == qProduct?.qonversionId);

        print(entitlement?.isActive);
      } on QPurchaseException catch (e) {
        // check if a user canceled the purchase
        // e.isUserCancelled
        print(e);
      }
    });
  }

  @override
  void dispose() {
    _updatedEntitlementsStream.cancel();
    _promoPurchasesStream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localOfferings = _offerings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        child: localOfferings == null
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  for (final p in _products) _productWidget(p),
                  _offeringsWidget(localOfferings),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: TextButton(
                      child: Text('Check Intro Eligibility'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.yellow),
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        try {
                          final ids = _products.map((product) => product.qonversionId).toList();
                          final res =
                              await Qonversion.getSharedInstance().checkTrialIntroEligibility(ids);

                          print(res.map(
                              (key, value) => MapEntry(key, value.status)));
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _loadOfferings() async {
    try {
      _offerings = await Qonversion.getSharedInstance().offerings();
      _loadProducts();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadProducts() async {
    try {
      var mainOffering = _offerings?.offeringForIdentifier("main");
      _products = mainOffering?.products ?? [];
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget _productWidget(QProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Store ID: ${product.storeId}'),
          subtitle: Text('Q ID: ${product.qonversionId}.\nStore Title: ${product.storeTitle}'),
          onTap: () => print(product.toJson()),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextButton(
            child: Text('Buy'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () async {
              try {
                final purchaseModel = product.toPurchaseModel();
                final entitlements =
                    await Qonversion.getSharedInstance().purchase(purchaseModel);
                final entitlement = entitlements.values.firstWhereOrNull((element) => element.productId == product.qonversionId);

                print(entitlement?.isActive);
              } on QPurchaseException catch (e) {
                // check if a user canceled the purchase
                // e.isUserCancelled
                print(e);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _offeringsWidget(QOfferings offerings) {
    final main = offerings.main;
    final availableOfferings = offerings.availableOfferings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('OFFERINGS:'),
        ),
        ..._offeringWidgets(main, true),
        if (availableOfferings.isNotEmpty)
          for (final offering in availableOfferings)
            ..._offeringWidgets(offering, false),
      ],
    );
  }

  List<Widget> _offeringWidgets(QOffering? offering, bool isMain) {
    if (offering == null) return <Widget>[];
    return [
      if (!isMain)
        ListTile(
          title: Text('ADDITIONAL AVAILABLE OFFERING:'),
        ),
      ListTile(
        title: Text('ID: ${offering.id}'),
        subtitle: Text('Tag: ${offering.tag}'),
      ),
      if (offering.products.isNotEmpty)
        for (final product in offering.products)
          ListTile(
            title: Text('Store ID: ${product.storeId}'),
            subtitle: Text('Q ID: ${product.qonversionId}'),
          )
    ];
  }
}
