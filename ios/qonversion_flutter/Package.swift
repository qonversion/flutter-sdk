// swift-tools-version: 5.9
import PackageDescription

// Swift Package Manager manifest for the iOS side of the plugin (Flutter 3.24+ with SwiftPM enabled,
// the default since Flutter 3.44). CocoaPods projects use ../qonversion_flutter.podspec instead;
// both pin the same QonversionSandwich version (`fastlane upgrade_sandwich` bumps them together).
let package = Package(
    name: "qonversion_flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "qonversion-flutter", targets: ["qonversion_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/qonversion/sandwich-sdk.git", exact: "7.13.0")
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
