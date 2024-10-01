import 'package:flutter/material.dart';

import 'home.dart';
import 'params_view.dart';
import 'products_view.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(SampleApp());
}

/// Entry point for the example application.
class SampleApp extends StatelessWidget {
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
