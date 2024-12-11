// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]),
    ],
    dependencies: [
      .package(name: "Utility", path: "../Utility"),
      .package(url: "https://github.com/hmlongco/Factory", exact: "2.3.2")
    ],
    targets: [
      .target(
        name: "Models",
        dependencies: [
          .product(
          name: "Utility",
          package: "Utility"
        ),
          "Factory"
        ]
      ),
    ]
)
