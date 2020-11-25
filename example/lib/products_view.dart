import 'package:flutter/material.dart';
import 'package:qonversion_example/home.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  Map<String, QProduct> _products;

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
                children: [...productsFromMap(_products)],
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
}
