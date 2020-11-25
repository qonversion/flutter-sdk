import 'package:flutter/material.dart';
import 'package:qonversion_example/products_view.dart';

import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => HomeView(),
        'products': (_) => ProductsView(),
      },
    );
  }
}
