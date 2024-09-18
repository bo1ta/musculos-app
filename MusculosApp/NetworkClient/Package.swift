// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkClient",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkClient",
            targets: ["NetworkClient"]),
    ],
    dependencies: [
      .package(name: "Utility", path: "../Utility"),
      .package(name: "Models", path: "../Models"),
      .package(name: "Storage", path: "../Storage"),
      .package(url: "https://github.com/hmlongco/Factory", exact: "2.3.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkClient",
            dependencies: [
              .product(name: "Utility", package: "Utility"),
              .product(name: "Models", package: "Models"),
              .product(name: "Storage", package: "Storage"),
              "Factory"
            ]
        ),
        .testTarget(
            name: "NetworkClientTests",
            dependencies: ["NetworkClient"]
        ),
    ]
)
