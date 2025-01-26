// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Components",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Components",
      targets: ["Components"]),
  ],
  dependencies: [
    .package(name: "Utility", path: "../Utility"),
    .package(url: "https://github.com/airbnb/HorizonCalendar", branch: "master"),
    .package(url: "https://github.com/markiv/SwiftUI-Shimmer", exact: "1.4.2"),
  ],
  targets: [
    .target(
      name: "Components",
      dependencies: [
        .product(name: "Utility", package: "Utility"),
        "HorizonCalendar",
        .product(name: "Shimmer", package: "SwiftUI-Shimmer"),
      ]),
  ])
