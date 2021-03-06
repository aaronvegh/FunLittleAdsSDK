// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FunLittleAdsSDK",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "FunLittleAdsSDK",
            targets: ["FunLittleAdsSDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FunLittleAdsSDK",
            swiftSettings: [
                .define("IS_RELEASE", .when(configuration: .release)),
            ]
        )
    ]
)
