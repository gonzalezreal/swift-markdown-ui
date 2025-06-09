// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "swift-markdown-ui",
  platforms: [
    .macOS(.v12),
    .iOS(.v16),
    .tvOS(.v15),
    .macCatalyst(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "MarkdownUI",
      targets: ["MarkdownUI"]
    ),
    .library(
      name: "cmark-gfm-internal-extensions",
      targets: ["cmark-gfm-internal-extensions"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/gonzalezreal/NetworkImage", from: "6.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.10.0"),
    .package(url: "https://github.com/swiftlang/swift-cmark", from: "0.4.0"),
    .package(url: "https://github.com/colinc86/LaTeXSwiftUI", from: "1.5.0"),
  ],
  targets: [
    .target(
      name: "MarkdownUI",
      dependencies: [
        "cmark-gfm-internal-extensions",
        .product(name: "cmark-gfm", package: "swift-cmark"),
        .product(name: "cmark-gfm-extensions", package: "swift-cmark"),
        .product(name: "NetworkImage", package: "NetworkImage"),
        .product(name: "LaTeXSwiftUI", package: "LaTeXSwiftUI")
      ]
    ),
    .target(
      name: "cmark-gfm-internal-extensions",
      dependencies: [
        .product(name: "cmark-gfm-extensions", package: "swift-cmark"),
      ],
      cSettings: [.define("CMARK_THREADING")],
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
