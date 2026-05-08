// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TIOPagingKit",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TIOPagingKit",
            targets: ["TIOPagingKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/codermjlee/mjrefresh", from: "3.7.9"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TIOPagingKit",
            dependencies: [
                .product(name: "MJRefresh", package: "MJRefresh")
            ]
        ),

    ],
)
