import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _mockTrack = false;
  String _uid = 'Not Initialized Qonversion Yet';
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Qonversion example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Qonversion uid: \n$_uid\n',
                textAlign: TextAlign.center,
              ),
              if (_products.isNotEmpty)
                Column(
                  children: [
                    for (final p in _products) Text(p.id),
                  ],
                ),
              StreamBuilder<List<PurchaseDetails>>(
                stream: InAppPurchaseConnection.instance.purchaseUpdatedStream,
                initialData: [],
                builder: (context, snapshot) {
                  final details = <Widget>[];
                  if (snapshot.hasData) {
                    for (final detail in snapshot.data) {
                      if (detail.status == PurchaseStatus.error) {
                        continue;
                      }
                      details.add(Text(detail.productID));
                    }
                  }

                  return Column(children: details);
                },
              ),
              FlatButton(
                child: Text('Track'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: makePurchase,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    String uid;
    try {
      uid = await Qonversion.launch('PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2');
      print('Did launch Q with uid: $uid');
    } catch (e) {
      print('Failed to obtain uid from Qonversion.');
      print(e);
    }

    if (!mounted) return;

    setState(() => _uid = uid);

    final purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });

    final available = await InAppPurchaseConnection.instance.isAvailable();
    if (!available) {
      print('Store is not available');
    }

    final _kIds = Set<String>.from(['qonversion_inapp_consumable']);
    final response =
        await InAppPurchaseConnection.instance.queryProductDetails(_kIds);

    for (final detail in response.productDetails) {
      print(detail.id);
    }

    setState(() => _products = response.productDetails);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (var i = 0; i < purchases.length; i++) {
      if (purchases[i].status == PurchaseStatus.error) {
        print('Bad purchase status');
        continue;
      }

      if (!purchases[i].billingClientPurchase.isAcknowledged) {
        print('Going to acknowledge purchase ${purchases[i].productID}');
        await InAppPurchaseConnection.instance.completePurchase(purchases[i]);
        print('Successfully acknowledged purchase ${purchases[i].productID}');
      }

      final uid =
          await Qonversion.manualTrackPurchase(_products[0], purchases[0]);
      print('Qonversion uid: $uid');
    }
  }

  void makePurchase() async {
    if (_mockTrack) {
      final uid = await Qonversion.manualTrackPurchase(
          getProductDetails(), getPurchaseDetails());
      print(uid);
      return;
    }
    final productDetails = _products[0];
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    final res = await InAppPurchaseConnection.instance
        .buyConsumable(purchaseParam: purchaseParam);

    print('Item purchased, result: $res');
  }

  ProductDetails getProductDetails() {
    // ignore: invalid_use_of_visible_for_testing_member
    final original = SkuDetailsWrapper(
      description: 'description',
      freeTrialPeriod: 'freeTrialPeriod',
      introductoryPrice: 'introductoryPrice',
      introductoryPriceMicros: 'introductoryPriceMicros',
      introductoryPriceCycles: null,
      introductoryPricePeriod: 'introductoryPricePeriod',
      price: 'price',
      priceAmountMicros: 1000,
      priceCurrencyCode: 'priceCurrencyCode',
      sku: 'sku',
      subscriptionPeriod: 'subscriptionPeriod',
      title: 'title',
      type: SkuType.inapp,
      isRewarded: true,
      originalPrice: 'originalPrice',
      originalPriceAmountMicros: 1000,
    );
    return ProductDetails.fromSkuDetails(original);
  }

  PurchaseDetails getPurchaseDetails() {
    // ignore: invalid_use_of_visible_for_testing_member
    final original = PurchaseWrapper(
      orderId: 'orderId',
      packageName: 'packageName',
      purchaseTime: 0,
      signature: 'signature',
      sku: 'sku',
      purchaseToken: 'purchaseToken',
      isAutoRenewing: false,
      originalJson: '{}',
      developerPayload: 'dummyPayload',
      isAcknowledged: true,
      purchaseState: PurchaseStateWrapper.purchased,
    );

    return PurchaseDetails.fromPurchase(original);
  }
}
