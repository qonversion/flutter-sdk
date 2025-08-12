## 10.0.2
* Fixed No-Codes source and version tracking for internal purposes.

## 10.0.1
* Fixed no-code screen action bar appearance issue.

## 10.0.0
### Introducing Qonversion No-Codes Beta!

**Qonversion No-Codes** is a product designed to help you **build and customize** paywall screens **without writing code**.
It allows seamless integration of pre-built subscription UI components, enabling a faster and more flexible way to design paywalls directly within your app. 
See more in the [documentation](https://documentation.qonversion.io/docs/getting-started-with-no-code-screens/).

With this update, we are **removing** deprecated **Automations**, so we encourage you to transition your paywalls to the new Qonversion No-Codes.

## 9.3.1
* Android and iOS stability improvements.

## 9.3.0
* Flutter version 3.29 supported.
* Deprecated Android Embedding v1 is no longer supported.
* Sample app gradle versions upgraded.

## 9.2.1
* Fixed update policy issue for purchase with options.

## 9.2.0
* iOS promotional offers supported. For the details see the [documentation](https://documentation.qonversion.io/docs/apple-promotional-offers).
* Minimal supported Dart SDK version is bumped to 2.14.0.

## 9.1.5
* Attempt to fix crash and race conditions in the User Properties manager.
* Fixed popover presentation style for iPad

## 9.1.4
* Added Tenjin AIID property for Tenjin integration
* The setNotificationToken, handleNotification, and `getNotificationCustomPayload` methods were marked as deprecated.

## 9.1.3
* Updated restore logic to process huge sandbox receipts faster.
* Fixed [products issue](https://github.com/qonversion/qonversion-ios-sdk/issues/507).
* Fixed [bundle issue](https://github.com/qonversion/qonversion-ios-sdk/issues/458).

## 9.1.2
* Added ability to call `purchase` without providing any options.

## 9.1.1
* iOS error codes improved

## 9.1.0
* Added option to set context keys, quantity, and other options for purchases. Context keys will allow you to associate the purchase with remote configuration if the product info was loaded from there.
* Deprecated old purchase functions. Use the new one instead.

## 9.0.2
* Fixed bug with `checkEntitlements` calls on Android when the callback might not have been called after subscription state changes during the app session.

## 9.0.1
* Internal SDK version fix.

## 9.0.0
New major release of Qonversion Flutter SDK with the new Google Play Billing Library 7 support!
* installment plans supported for subscriptions
* fallback files support added for improved reliability
* several error code values updated

For the migration steps and the complete list of changes, see the following [guide](https://documentation.qonversion.io/docs/android-8-migration-guide).

## 8.5.0
* Internal logic update

## 8.4.1
* Fixed the issue with the `QRemoteConfigurationSource` parsing.

## 8.4.0
* Added returning promise to the `identify` method. You may see warnings for ignoring the returned promise after updating to this version until you update the usage to asynchronous. If you don't need to know the identification result, simply ignore it.

## 8.3.1
* Fixed privacy manifest file

## 8.3.0
* Added functions to request remote config list - either all or for a specific set of context keys.

## 8.2.0
* Added an option to load Remote Configs by the specific context keys using the `remoteConfig` method.

## 8.1.0
* Added 4 new properties for AppMetrica and PushWoosh integrations - `appMetricaDeviceId`, `appMetricaUserProfileId`, `pushWooshHwId`, `pushWooshUserId`.
* Updated entitlements cache logic - the case with entitlement expiration during the app session handled.

## 8.0.0
New major release of Qonversion Android SDK with the new Google Play Billing features support!
* added base plans and offers support;
* Gradle on Android was upgraded to the version 8;
* the `checkTrialIntroEligibility` method improved and now detects the eligibility based on store details on Android;
* the `QProductDuration` and `QTrialDuration` classes were removed;
* the `QProrationMode` enum was removed and replaced with `QPurchaseUpdatePolicy`.

For the complete release notes with the migration guide please see [the documentation](https://documentation.qonversion.io/docs/flutter-8-migration-guide).

## 7.3.2
* Fixed restore issue for iOS

## 7.3.1
* Fixed restore issue

## 7.3.0
* Updated entitlements fields

## 7.2.0
* Added attach/detach remote configuration functions

## 7.1.0
* Added remote configuration source property.
* Added rate limits for API calls.

## 7.0.1
* Fixed a small bug with setting `advertisingId` property on Android.

## 7.0.0
* New `userProperties` method to get all the properties set for the current user.
* Renamings of several entities and public methods to make our namings and structure clearer.

## 6.1.2
* Android 14 support.

## 6.1.1
* Internal logic update

## 6.1.0
* Updated A/B experiments

## 5.4.1
* Added native SDK crash tracking.

## 5.4.0
* Added function to sync transactions for StoreKit 2. The function should be used only in rare cases to avoid StoreKit 2 bugs. Contact us before using that function.
* Parallel requests and race conditions fixed for entitlements state changing calls.

## 5.3.1
* Fixed `collectAppleSearchAdsAttribution` call bug (`NoNecessaryDataError, Could not find necessary arguments`).

## 5.3.0
* Added function to sync the user's historical data.

## 5.2.0
* Added a function to enable Qonversion SDK Kids mode via the builder on Android. With this mode activated, our SDK does not collect any information that violates Google Children’s Privacy Policy.
* Fixed possible rare ANR (Application Not Responding) errors during Facebook Attribution collection on Android.
* ! Small breaking change - the property `QUser.identityId` is made nullable as it should be. Take it into account if you are using Dart null-safety.

## 5.1.0
* Added an option to customize screen presentation style.
* Added an option to set proxy URL for Qonversion API.

## 5.0.1
* Fixed rare runtime error after migrating from previous major SDK version.

## 5.0.0
* New major version of Qonversion Flutter SDK. See the documentation for the changes list of changes and the migration guide.

## 4.6.1
* Fixed an issue causing automation event losses on Android.
* Fixed a rare issue with the permissions cache on Android.

## 4.6.0
* Added a `source` property to the `Permission` object - use it to know where this permission is originally from - App Store, Play Store, Stripe, etc.
* Added a method `getNotificationCustomPayload` to get the extra data you've added to automation notifications.
* Added a method `presentCodeRedemptionSheet` to show up a sheet for users to redeem AppStore offer codes (iOS 14+ only).
* Purchase tracking error handling improved to guarantee delivery.

## 4.5.2
* Added a new user property `AppSetId` - a unique user identifier for all the developer's applications. May be used for some integrations.

## 4.5.1
* Fixed `Could not find offeringId value` error for `purchaseProduct` call on iOS.

## 4.5.0
* Big refactoring of the native modules made to simplify further upgrades and make it easy to keep the SDK functionality up-to-date.

## 4.4.0
* Added support of network connection lack or unexpected backend errors. Now Qonversion SDK will handle user permissions correctly even if it can't reach out to the API and will actualize them with the next successful request. Also, products and offerings become permanently available after the first successful launch - nothing will interfere user from the purchase.
* Added method `setPermissionsCacheLifetime` to configure the lifetime of permissions cache. It is used if we faced any error trying to get permissions from our API. Defaults to one month.
* Added a new defined property `FirebaseAppInstanceId` for Firebase integration.
* _(Android only)_ Fixed a bug with introductory price tracking causing wrong data in the analytics dashboard for some purchases.

## 4.3.4
* Updated native SDK versions. Android 3.2.4 -> 3.2.9. iOS 2.18.3 -> 2.19.1.

## 4.3.3
* Added `purchaseProduct` function for Mac OS.

## 4.3.2
* Fixed Android null-safety compilation issue in Flutter 3+.

## 4.3.1
* Added Apple Search Ads support.
* Method `setUserId` marked as deprecated.

## 4.3.0
* Qonversion Automation allows sending automated, personalized push notifications and in-app messages initiated by in-app purchase events.
This feature is designed to increase your app's revenue and retention, provide cancellation insights, reduce subscriber churn, and improve your subscribers' user experience.
See more in the [documentation](https://documentation.qonversion.io/docs/automations).

## 4.2.0
* Add `setAppleSearchAdsAttributionEnabled()` method

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
