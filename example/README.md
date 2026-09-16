# qonversion_flutter example

Demonstrates how to use the `qonversion_flutter` plugin on Android, iOS and macOS.

## Requirements

- Flutter 3.27+ (the iOS and macOS runners are integrated with Swift Package Manager; on Flutter 3.27–3.34 build with `flutter build` / `flutter run` so Flutter raises the generated plugin package to the app's deployment target).
- iOS 13.0+ / macOS 10.15+ — the minimums of the plugin with both package managers.
- To build with CocoaPods instead of Swift Package Manager: `flutter config --no-enable-swift-package-manager`, then `flutter clean` and build again.

The iOS and macOS runners share the bundle id `io.qonversion.sample`, which the example's Qonversion project and its StoreKit products are configured for.
