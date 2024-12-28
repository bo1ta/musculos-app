// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DataRepository",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "DataRepository",
      targets: ["DataRepository"]
    ),
  ],
  dependencies: [
    .package(name: "Utility", path: "../Utility"),
    .package(name: "Models", path: "../Models"),
    .package(name: "Storage", path: "../Storage"),
    .package(name: "NetworkClient", path: "../NetworkClient"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.3.2"),
    .package(url: "https://github.com/mattmassicotte/Queue", from: "0.1.4"),
  ],
  targets: [
    .target(
      name: "DataRepository",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Models", package: "Models"),
        .product(name: "Storage", package: "Storage"),
        .product(name: "NetworkClient", package: "NetworkClient"),
        "Factory",
        "Queue",
      ]
    ),
    .testTarget(
      name: "DataRepositoryTests",
      dependencies: ["DataRepository"]
    ),
  ]
)
