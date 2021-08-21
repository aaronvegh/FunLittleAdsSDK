// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FunLittleAdsSDK",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
    products: [
        .library(
            name: "FunLittleAdsSDK",
            targets: ["FunLittleAdsSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/aaronvegh/SwURL", .branch("macos-support"))
    ],
    targets: [
        .target(
            name: "FunLittleAdsSDK",
            dependencies: ["SwURL"])
    ]
)
