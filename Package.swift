// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PyCodable",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PyCodable",
            targets: ["PyCodable"]
		),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(path: "../PythonSwiftLink-development"),
		.package(
			url: "https://github.com/PythonSwiftLink/PySwiftKit",
			from: .init(311, 0, 0)
		)
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PyCodable",
            dependencies: [
				.product(name: "PySwiftKit", package: "PySwiftKit")
			],
            path: "Sources"
        ),
//        .testTarget(
//            name: "PyCodableTests",
//            dependencies: ["PyCodable"],
//            path: "Tests"
//        ),
    ]
)
