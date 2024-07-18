// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Components",
            targets: ["Components"]),
    ],
    dependencies: [
      .package(name: "Utility", path: "../Utility"),
    ],
    targets: [
      .target(
        name: "MusculosApp",
        dependencies: [.product(
          name: "Utility",
          package: "Utility"
        )]
      ),
      .target(
        name: "Components",
        dependencies: [
            .product(name: "Utility", package: "Utility")
        ]
      ),

    ]
)
