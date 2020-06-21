import 'package:flutter/material.dart';
import 'dart:async';

import 'package:qonversion_flutter/qonversion.dart';

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
      uid = await Qonversion.launch(
        iosApiKey: '',
        androidApiKey: '',
      );
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
          child: Text(
            'Qonversion uid: \n$_uid\n',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
