import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class ParamsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Params Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton(
              child: Text('Set User ID'),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                Qonversion.setUserId('customId');
                print('did set user id');
              },
            ),
            FlatButton(
              child: Text('Set User Property'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Qonversion.setUserProperty('customProperty', 'customValue');
                print('did set user property');
              },
            ),
            for (final v in QUserProperty.values)
              FlatButton(
                child: Text('Set ${describeEnum(v)}'),
                color: Colors.purple,
                textColor: Colors.white,
                onPressed: () {
                  Qonversion.setProperty(v, 'email@email.com');
                  print('did set property');
                },
              ),
          ],
        ),
      ),
    );
  }
}
