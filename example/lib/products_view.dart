import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  var _products = <QProduct>[];
  QOfferings _offerings;
  StreamSubscription<Map<String, QEntitlement>> _updatedEntitlementsStream;
  StreamSubscription<String> _promoPurchasesStream;

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
        final qProduct = _products.firstWhere(
            (element) => element.storeId == promoPurchaseId,
            orElse: () => null);
        // Get entitlement by Qonversion product
        final entitlement = entitlements.values.firstWhere(
            (element) => element.productId == qProduct?.qonversionId,
            orElse: () => null);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        child: _products == null && _offerings == null
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  if (_products != null)
                    for (final p in _products) _productWidget(p),
                  if (_offerings != null) _offeringsWidget(_offerings),
                  if (_products != null)
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: FlatButton(
                        child: Text('Check Intro Eligibility'),
                        color: Colors.yellow,
                        textColor: Colors.black,
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
      var mainOffering = _offerings.offeringForIdentifier("main");
      _products = mainOffering.products;
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
          child: FlatButton(
            child: Text('Buy'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () async {
              try {
                final QPurchaseModel purchaseModel = product.toPurchaseModel();
                final QPurchaseUpdateModel purchaseUpdateModel = product.toPurchaseUpdateModel('oldProductId', updatePolicy: QPurchaseUpdatePolicy.withTimeProration);
                final QPurchaseModel purchaseModel = new QPurchaseModel();
                purchaseModel.offerId = 'frefr';
                final QPurchaseUpdateModel purchaseUpdateModel = new QPurchaseUpdateModel("newProductId", "oldProductId", updatePolicy: QPurchaseUpdatePolicy.withTimeProration);

// Specifying purchase update policy after the purchase update model creation:
                purchaseUpdateModel.updatePolicy = QPurchaseUpdatePolicy.withTimeProration;
                final entitlements =
                    await Qonversion.getSharedInstance().purchase(purchaseModel);
                final entitlement = entitlements.values.firstWhere(
                    (element) => element.productId == product.qonversionId,
                    orElse: () => null);

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
        if (availableOfferings != null && availableOfferings.isNotEmpty)
          for (final offering in availableOfferings)
            ..._offeringWidgets(offering, false),
      ],
    );
  }

  List<Widget> _offeringWidgets(QOffering offering, bool isMain) {
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
