// swift-tools-version:5.3

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
            name: "SwiftCommonMark",
            url: "https://github.com/gonzalezreal/SwiftCommonMark",
            from: "0.1.0"
        ),
        .package(
            name: "AttributedText",
            url: "https://github.com/gonzalezreal/AttributedText",
            from: "0.3.0"
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
            name: "MarkdownUI",
            dependencies: [
                .product(name: "CommonMark", package: "SwiftCommonMark"),
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
