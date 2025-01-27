// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RouteKit",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "RouteKit",
      targets: ["RouteKit"]),
  ],
  dependencies: [
    .package(name: "Utility", path: "../Utility"),
    .package(name: "Components", path: "../Components"),
    .package(name: "DataRepository", path: "../DataRepository"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.4.3"),
    .package(url: "https://github.com/lucaszischka/BottomSheet", exact: "3.1.1"),
  ],
  targets: [
    .target(
      name: "RouteKit",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Components", package: "Components"),
        .product(name: "DataRepository", package: "DataRepository"),
        "Factory",
        "BottomSheet",
      ]),
    .testTarget(
      name: "RouteKitTests",
      dependencies: ["RouteKit"]),
  ])
