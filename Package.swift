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
            name: "CommonMark",
            targets: ["CommonMark"]
        ),
        .library(
            name: "MarkdownUI",
            targets: ["MarkdownUI"]
        ),
    ],
    dependencies: [
        .package(
            name: "cmark",
            url: "https://github.com/SwiftDocOrg/swift-cmark.git",
            from: Version(
                0, 28, 3,
                prereleaseIdentifiers: [],
                buildMetadataIdentifiers: ["20200207", "1168665"]
            )
        ),
        .package(
            name: "AttributedText",
            url: "https://github.com/gonzalezreal/AttributedText",
            from: "0.2.1"
        ),
        .package(
            name: "NetworkImage",
            url: "https://github.com/gonzalezreal/NetworkImage",
            from: "2.1.0"
        ),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.1.2"),
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.8.2"
        ),
    ],
    targets: [
        .target(
            name: "CommonMark",
            dependencies: [
                "cmark",
            ]
        ),
        .testTarget(
            name: "CommonMarkTests",
            dependencies: [
                "CommonMark",
            ]
        ),
        .target(
            name: "MarkdownUI",
            dependencies: [
                "CommonMark",
                "AttributedText",
                "NetworkImage",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
        .testTarget(
            name: "MarkdownUITests",
            dependencies: [
                "MarkdownUI",
                "SnapshotTesting",
            ],
            exclude: ["__Snapshots__"]
        ),
    ]
)
