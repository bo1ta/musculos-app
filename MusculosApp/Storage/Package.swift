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
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.4.3"),
    .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.0.0"),
    .package(url: "https://github.com/mattmassicotte/Queue", from: "0.1.4"),
    .package(url: "https://bitbucket.org/iam_apps/principle/src/master/Principle/", .upToNextMajor(from: "1.5.0")),
  ],
  targets: [
    .target(
      name: "Storage",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        .product(name: "Models", package: "Models"),
        "Factory",
        "Fakery",
        "Queue",
        "Principle"
      ]),
    .testTarget(
      name: "StorageTests",
      dependencies: ["Storage"]),
  ])
