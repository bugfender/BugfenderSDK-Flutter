// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_bugfender",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-bugfender", targets: ["flutter_bugfender"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/bugfender/BugfenderSDK-iOS", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "flutter_bugfender",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "BugfenderLibrary", package: "BugfenderSDK-iOS")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_bugfender")
            ]
        )
    ]
)
