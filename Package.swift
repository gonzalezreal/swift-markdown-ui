// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "MarkdownUI",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
  ],
  products: [
    .library(
      name: "MarkdownUI",
      targets: ["MarkdownUI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.9.0")
  ],
  targets: [
    .target(
      name: "MarkdownUI",
      dependencies: []
    ),
    .testTarget(
      name: "MarkdownUITests",
      dependencies: [
        "MarkdownUI",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ],
      exclude: ["__Snapshots__"]
    ),
  ]
)
