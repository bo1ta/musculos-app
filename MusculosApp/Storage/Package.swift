// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Storage",
  platforms: [.iOS(.v17)],
  products: [
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
