// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NetworkClient",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "NetworkClient",
      targets: ["NetworkClient"]),
  ],
  dependencies: [
    .package(name: "Utility", path: "../Utility"),
    .package(name: "Models", path: "../Models"),
    .package(name: "Storage", path: "../Storage"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.4.3"),
    .package(url: "https://github.com/mattmassicotte/Queue", from: "0.1.4"),
  ],
  targets: [
    .target(
      name: "NetworkClient",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Models", package: "Models"),
        .product(name: "Storage", package: "Storage"),
        "Factory",
        "Queue",
      ]),
    .testTarget(
      name: "NetworkClientTests",
      dependencies: ["NetworkClient"],
      resources: [
        .process("Supporting Files"),
      ]),
  ])
