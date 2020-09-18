import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _uid = 'Not Initialized Qonversion Yet';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String uid;
    try {
      uid = await Qonversion.launch('2GDfAtgresyVOLHx1PfWQogIP1-FKOVb');
      print(uid);
    } catch (e) {
      print('Failed to obtain uid from Qonversion.');
      print(e);
    }

    if (!mounted) return;

    setState(() => _uid = uid);
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
              FlatButton(
                child: Text('Track'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  final uid = await Qonversion.manualTrackPurchase(
                      getProductDetails(), getPurchaseDetails());
                  print(uid);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ProductDetails getProductDetails() {
    // ignore: invalid_use_of_visible_for_testing_member
    final original = SkuDetailsWrapper(
      description: 'description',
      freeTrialPeriod: 'freeTrialPeriod',
      introductoryPrice: 'introductoryPrice',
      introductoryPriceMicros: 'introductoryPriceMicros',
      introductoryPriceCycles: 'introductoryPriceCycles',
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
