// swift-tools-version: 5.9
import PackageDescription

// Swift Package Manager manifest for the macOS side of the plugin (Flutter 3.24+ with SwiftPM enabled,
// the default since Flutter 3.44). CocoaPods projects use ../qonversion_flutter.podspec instead;
// both pin the same QonversionSandwich version (`fastlane upgrade_sandwich` bumps them together).
let package = Package(
    name: "qonversion_flutter",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "qonversion-flutter", targets: ["qonversion_flutter"])
    ],
    // No FlutterFramework dependency on purpose: Flutter 3.24–3.40 reference plugins by absolute path and
    // ship no FlutterFramework package next to them, so declaring it would break SwiftPM resolution for those
    // users. Flutter's first-party plugins do the same. Revisit once the supported Flutter floor is >= 3.41.
    dependencies: [
        .package(url: "https://github.com/qonversion/sandwich-sdk.git", exact: "7.13.1")
    ],
    targets: [
        .target(
            name: "qonversion_flutter",
            dependencies: [
                .product(name: "QonversionSandwich", package: "sandwich-sdk")
            ]
        )
    ]
)
