// swift-tools-version: 5.8.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AcCollections",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AcCollections",
            targets: ["AcCollections"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
      .testTarget(
          name: "AcCollections",
          dependencies: ["tree"]
      ),
        .target(
            name: "tree"),
        .testTarget(
            name: "treeTests",
            dependencies: ["tree"]
        ),
        .executableTarget(
            name: "Executable",
            dependencies: [
                "tree" ]
            )
    ]
)
