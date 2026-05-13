// swift-tools-version: 5.9
// Flutter SPM integration. Consumed when the app enables SPM via
// `flutter config --enable-swift-package-manager`. Plugin authors must ship
// both this Package.swift and the podspec until Flutter EOLs CocoaPods.
import PackageDescription

let package = Package(
    name: "qonversion_flutter",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "qonversion-flutter", targets: ["qonversion_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/qonversion/sandwich-sdk.git", exact: "7.10.0")
    ],
    targets: [
        .target(
            name: "qonversion_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "QonversionSandwich", package: "sandwich-sdk")
            ],
            cSettings: [
                .headerSearchPath("include/qonversion_flutter")
            ]
        )
    ]
)
