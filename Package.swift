// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ErrorHandler",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .tvOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ErrorHandler",
            targets: ["ErrorHandler"]),
    ],
    dependencies: [
        .package(
            name: "AlertToast",
            url: "https://github.com/elai950/AlertToast.git",
            from: "1.3.7"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ErrorHandler",
            dependencies: ["AlertToast"]
        ),
        .testTarget(
            name: "ErrorHandlerTests",
            dependencies: ["ErrorHandler"]
        ),
    ]
)
