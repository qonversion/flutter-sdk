import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  var _products = <String, QProduct>{};
  QOfferings _offerings;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadOfferings();
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
                    for (final p in _products.values) _productWidget(p),
                  if (_offerings != null) _offeringsWidget(_offerings)
                ],
              ),
      ),
    );
  }

  Future<void> _loadProducts() async {
    try {
      _products = await Qonversion.products();
      setState(() {});
    } catch (e) {
      print(e);
      _products = {};
    }
  }

  Future<void> _loadOfferings() async {
    try {
      _offerings = await Qonversion.offerings();
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
          subtitle: Text('Q ID: ${product.qonversionId}'),
          trailing: product.skProduct != null
              ? Text(product.skProduct.localizedTitle)
              : null,
          onTap: () => print(product.toJson()),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: FlatButton(
            child: Text('Buy'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () async {
              final res = await Qonversion.purchase(product.qonversionId);
              print(res[product.qonversionId]?.isActive);
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
            trailing: product.skProduct != null
                ? Text(product.skProduct.localizedTitle)
                : null,
          )
    ];
  }
}
