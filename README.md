<p align="center">
 <a href="https://qonversion.io" target="_blank"><img width="460" height="150" src="https://qonversion.io/img/q_brand.svg"></a>
</p>

<p align="center">
     <a href="https://qonversion.io"><img width="660" src="https://qonversion.io/img/illustrations/charts.svg"></a></p>

Get access to the powerful yet simple subscription analytics:
* Conversion from install to paying user, MRR, LTV, churn and other metrics.
* Feed the advertising and analytics tools you are already using with the data on high-value users to improve your ads targeting and marketing ROAS.

[![Pub](https://img.shields.io/pub/v/qonversion_flutter.svg)](https://pub.dev/packages/qonversion_flutter)

## Installation
To use Qonversion in your Flutter app, add `qonversion` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/): 

```
dependencies:
  qonversion_flutter: ^0.3.0
```

Run `flutter pub get` to install dependency.

## Usage 
You need to configure Qonversion once at a starting point of your app. 

For example, launch Qonversion in `initState` of your top level widget: 

```
...
import 'package:qonversion_flutter/qonversion.dart';

...

String _qonversionUserId;

@override
void initState() {
  super.initState();
  
  _launchQonversion();
}

Future<String> _launchQonversion() async {
  _qonversionUserId = await Qonversion.launch(
    iosApiKey: 'YOUR_IOS_API_KEY',
    androidApiKey: 'YOUR_ANDROID_API_KEY',
  );
}

...
```

Qonversion will track purchases automatically.

You can also specify your client side `userId` (instead of Qonversion user-id) that will be used for matching data in the third party data:

```
final userId = 'CLIENT_SIDE_USER_ID';
Qonversion.launch(
  iosApiKey: 'YOUR_IOS_API_KEY',
  androidApiKey: 'YOUR_ANDROID_API_KEY',
  userId: userId,
);
```

## License

Qonversion SDK is available under the MIT license.
