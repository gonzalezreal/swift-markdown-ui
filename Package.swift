// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonMarkUI",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v11),
    ],
    products: [
        .library(
            name: "CommonMarkUI",
            targets: ["CommonMarkUI"]
        ),
    ],
    dependencies: [
        .package(
            name: "cmark",
            url: "https://github.com/apple/swift-cmark",
            .revision("9c8096a23f44794bde297452d87c455fc4f76d42")
        ),
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.8.2"
        ),
    ],
    targets: [
        .target(
            name: "CommonMarkUI",
            dependencies: ["cmark"]
        ),
        .testTarget(
            name: "CommonMarkUITests",
            dependencies: [
                "CommonMarkUI",
                "SnapshotTesting",
            ],
            exclude: [
                "__Fixtures__",
                "__Snapshots__",
            ]
        ),
    ]
)
