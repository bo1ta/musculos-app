// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RouteKit",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "RouteKit",
      targets: ["RouteKit"]
    ),
  ],
  dependencies: [
    .package(name: "Utility", path: "../Utility"),
    .package(name: "Components", path: "../Components"),
  ],
  targets: [
    .target(
      name: "RouteKit",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Components", package: "Components"),
      ]
    ),
    .testTarget(
      name: "RouteKitTests",
      dependencies: ["RouteKit"]
    ),
  ]
)
