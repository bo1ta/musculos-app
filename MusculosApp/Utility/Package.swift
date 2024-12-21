// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utility",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Utility",
            targets: ["Utility"]),
    ],
    dependencies: [
      .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "Utility",
          dependencies: [
            "SwiftyBeaver",
          ]
        ),
    ]
)
