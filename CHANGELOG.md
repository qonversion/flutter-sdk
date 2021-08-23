## 4.1.1
* Fix StrictMode policy violation errors in the Google Play Console pre-launch report.

## 4.1.0
* New Product fields: storeTitle, storeDescription, price, currencyCode, prettyIntroductoryPrice.
* Improved errors details.

## 4.0.0
* From now Qonversion supports Google Play Billing Library 4.0.0 version for Android.

## 3.3.0
* Add `purchaseProduct()`, `updatePurchaseWithProduct()`
* Deprecate `resetUser()`

## 3.2.1
* Fix enum dependencies

## 3.2.0
* Add support for Android v2 embedding

## 3.1.0
* Add support for promo purchases on iOS
* Add Identity support

## 3.0.1
* Fix QOfferings mapping error
* Internal logic optimization for Android

## 3.0.0
* Add null safety support 
* Increase min Dart SDK version to 2.12.0

## 2.5.2
* SKProduct issue fix
* Unfinished transactions fix
* Minor improvements

## 2.5.1
* iOS 14.5 advertising ID support

## 2.5.0
* MacOS support

## 2.4.1
* Internal logic optimization and minor improvements

## 2.4.0
* Add deferred purchases feature

## 2.3.0
* From now SDK will return all requested info (products/offerings/permissions) even in case of an internet connection error, the server problem, etc if cached data is not outdated.

## 2.2.0
* Add Offerings feature
* Add `trialDuration` property to `product`
* Add `checkTrialIntroEligibility` method
* Bugfixes and improvements under the hood

## 2.1.0
* Add `setDebugMode()` method

## 2.0.1
* Fix iOS timestamp mapping

## 2.0.0
* We have rethought our approach to working with subscriptions and prepared our largest update that includes [Product Center](https://documentation.qonversion.io/docs/product-center) – our major feature for working with any type in-app purchases.

## 1.1.2
* Fix Android `manualTrackPurchase` args parsing
* Update Example app

## 1.1.1
* Update docs

## 1.1.0
* Add convenient `manualTrackPurchase` method to easily track purchases on Android

## 1.0.1
* Downgrade Android Qonversion SDK to version 1.0.4 in order to use Android Billing Library ver. 2.2.0 instead of ver. 3.0.0 since Flutter in_app_purchases does not support it.

## 1.0.0

* API update: new `launch` method with just one API key argument for both platforms. Contact us at hi@qonversion.io to merge your old API keys into one, [we can do it now](https://qonversion.io/docs/crossplatform-project).
* API update: Remove old `launch` method; remove all old `launch...` methods.
* Add `trackPurchase` method to track Android purchases manually.
* Add `addAttributionData` method implementation for Android.

## 0.3.0

* API update: new `launch` method, deprecate all old `launch...` methods
* Fix Android init

## 0.2.5

* Fix Android error handling

## 0.2.4

* Bump Android SDK Version

## 0.2.3

* Bump required Flutter version up

## 0.2.2

* Add link to GitHub repository to pubspec.yaml

## 0.2.1

* Minor documentation updates

## 0.2.0

* Release 0.2.0
