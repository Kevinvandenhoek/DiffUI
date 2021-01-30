// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DiffUI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DiffUI",
            targets: ["DiffUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nakiostudio/EasyPeasy.git", from: "1.10.0"),
    ],
    targets: [
        .target(
            name: "DiffUI",
            dependencies: []),
        .testTarget(
            name: "DiffUITests",
            dependencies: ["DiffUI"]),
    ]
)
