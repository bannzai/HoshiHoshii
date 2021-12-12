// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApolloCodegen",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(name: "Apollo",
                 url: "https://github.com/apollographql/apollo-ios.git",
                 .upToNextMinor(from: "0.49.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ApolloCodegen",
            dependencies: [
                .product(name: "ApolloCodegenLib", package: "Apollo"),
            ]),
        .testTarget(
            name: "ApolloCodegenTests",
            dependencies: ["ApolloCodegen"]),
    ]
)
