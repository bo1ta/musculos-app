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
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.4.3"),
  ],
  targets: [
    .target(
      name: "RouteKit",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Components", package: "Components"),
        "Factory",
      ]),
    .testTarget(
      name: "RouteKitTests",
      dependencies: ["RouteKit"]),
  ])
