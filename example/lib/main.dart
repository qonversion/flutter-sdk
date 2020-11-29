import 'package:flutter/material.dart';

import 'home.dart';
import 'params_view.dart';
import 'products_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => HomeView(),
        'products': (_) => ProductsView(),
        'params': (_) => ParamsView()
      },
    );
  }
}
