// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaFilterKit",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "MediaFilterKit",
            targets: ["MediaFilterKit"]),
    ],
    targets: [
        .target(
            name: "MediaFilterKit",
            dependencies: []),
        .testTarget(
            name: "MediaFilterKitTests",
            dependencies: ["MediaFilterKit"]),
    ]
)
