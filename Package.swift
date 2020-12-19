// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarkdownUI",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3),
    ],
    products: [
        .library(
            name: "MarkdownUI",
            targets: ["MarkdownUI"]
        ),
    ],
    dependencies: [
        .package(
            name: "cmark",
            url: "https://github.com/apple/swift-cmark",
            .revision("9c8096a23f44794bde297452d87c455fc4f76d42")
        ),
        .package(
            name: "AttributedText",
            url: "https://github.com/gonzalezreal/AttributedText",
            from: "0.1.0"
        ),
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.8.2"
        ),
    ],
    targets: [
        .target(
            name: "MarkdownUI",
            dependencies: ["cmark", "AttributedText"]
        ),
        .testTarget(
            name: "MarkdownUITests",
            dependencies: [
                "MarkdownUI",
                "SnapshotTesting",
            ],
            exclude: [
                "__Fixtures__",
                "__Snapshots__",
            ]
        ),
    ]
)
