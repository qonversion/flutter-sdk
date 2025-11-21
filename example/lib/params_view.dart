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
            TextButton(
              child: Text('Get user properties'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.amber),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                try {
                  QUserProperties userProperties =
                      await Qonversion.getSharedInstance().userProperties();
                  userProperties.properties.forEach((userProperty) {
                    print('User property - key: ' +
                        userProperty.key +
                        ', value: ' +
                        userProperty.value);
                  });
                } catch (e) {
                  // handle error here
                }
              },
            ),
            TextButton(
              child: Text('Set User ID'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Qonversion.getSharedInstance().setUserProperty(QUserPropertyKey.customUserId, 'customId');
                print('did set user id');
              },
            ),
            TextButton(
              child: Text('Set User Property'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Qonversion.getSharedInstance().setCustomUserProperty('customProperty', 'customValue');
                print('did set user property');
              },
            ),
            for (final v in QUserPropertyKey.values)
              TextButton(
                child: Text('Set ${v.name}'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.purple),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Qonversion.getSharedInstance().setUserProperty(v, 'email@email.com');
                  print('did set property');
                },
              ),
          ],
        ),
      ),
    );
  }
}
