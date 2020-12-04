import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  var _products = <String, QProduct>{};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        child: _products == null
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  for (final p in _products.values) _productWidget(p),
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
}
