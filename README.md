<p align="center">
     <a href="https://qonversion.io"><img width="260" src="https://qonversion.io/img/brand.svg"></a>
</p>

<p align="center">
     <a href="https://qonversion.io"><img width="660" src="https://qonversion.io/img/illustrations/charts.svg"></a></p>

Get access to the powerful yet simple subscription analytics:
* Conversion from install to paying user, MRR, LTV, churn and other metrics.
* Feed the advertising and analytics tools you are already using with the data on high-value users to improve your ads targeting and marketing ROAS.

[![Pub](https://img.shields.io/pub/v/qonversion.svg)](https://pub.dev/packages/qonversion)

## Installation
To use Qonversion in your Flutter app, add `qonversion` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/): 

```
dependencies:
  qonversion: ^0.2
```

Run `flutter pub get` to install dependency.

## Usage 
You need to configure Qonversion once at a starting point of your app. 

For example, launch Qonversion in `initState` of your top level widget: 

```
...
import 'package:qonversion/qonversion.dart';

...

@override
void initState() {
  super.initState();
  Qonversion.launchWith(
    iosApiKey: 'YOUR_IOS_API_KEY',
    androidApiKey: 'YOUR_ANDROID_API_KEY',
    onComplete: (uid) => print(uid),
  );
}

...
```

Usually Qonversion will track purchases automatically.

Still, there are few ways to launch Qonversion:

1. Launches Qonversion SDK with the given API keys for each platform: [androidApiKey] and [iosApiKey] respectively.
[onComplete] will return `uid` for Ads integrations.

```subscriptions, basic purchases) automatically.
static Future<void> launchWith({
  String androidApiKey,
  String iosApiKey,
  void Function(String) onComplete,
})
```

2. Same as previous but allows you to specify client side `userid` (instead of Qonversion user-id) that will be used for matching data in the third party data:

```
static Future<void> launchWithClientSideUserId(
    String userID, {
    String androidApiKey,
    String iosApiKey,
})
```

3. **Under development**. Same as previous but allows you to turn off auto tracking purchases and track it manually.

```
static Future<void> launchWithAutoTrackPurchases(
    bool autoTrackPurchases, {
    String androidApiKey,
    String iosApiKey,
    void Function(String) onComplete,
})
```

## License

Qonversion SDK is available under the MIT license.
