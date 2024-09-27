// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utility",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Utility",
            targets: ["Utility"]),
    ],
    dependencies: [
      .package(url: "https://github.com/hmlongco/Factory", exact: "2.3.2"),
      .package(url: "https://github.com/markiv/SwiftUI-Shimmer", exact: "1.4.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "Utility",
          dependencies: [
            .product(name: "Factory", package: "Factory"),
            .product(name: "Shimmer", package: "SwiftUI-Shimmer")
          ]
        ),
        .testTarget(
            name: "UtilityTests",
            dependencies: ["Utility"]
        ),
    ]
)
