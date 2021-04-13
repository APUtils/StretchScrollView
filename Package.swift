// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StretchScrollView",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
    ],
    products: [
        .library(
            name: "StretchScrollView",
            targets: ["StretchScrollView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/APUtils/ViewState.git", .upToNextMajor(from: "1.2.1")),
    ],
    targets: [
        .target(
            name: "StretchScrollView",
            dependencies: ["ViewState"],
            path: "StretchScrollView/Classes",
            exclude: []),
    ]
)
