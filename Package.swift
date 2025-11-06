// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "monri-ios",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "Monri",
            targets: ["Monri"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0")
    ],
    targets: [
        .target(
            name: "Monri",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Monri/Classes",
            resources: [
                .process("../Assets"),
            ]
        )
    ]
)
