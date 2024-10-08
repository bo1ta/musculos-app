// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Storage",
  platforms: [.iOS(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Storage",
      targets: ["Storage"]),
  ],
  dependencies: [
    .package(name: "Utility", path: "../Utility"),
    .package(name: "Models", path: "../Models"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.3.2"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "MusculosApp",
      dependencies: [
        .product(
          name: "Utility",
          package: "Utility"
        ),
        .product(
          name: "Models",
          package: "Models"
        ),
        "Factory"
      ]
    ),
    .target(
      name: "Storage",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Models", package: "Models")
      ]
    ),
    .testTarget(
      name: "StorageTests",
      dependencies: ["Storage"]
    ),
  ]
)
