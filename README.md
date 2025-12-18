# MarkdownDiff

A fork of [gonzalezreal/swift-markdown-ui](https://github.com/gonzalezreal/swift-markdown-ui) that adds `MarkdownDiff` - a simple way to display diffs between two Markdown strings in SwiftUI.

For full documentation on the base MarkdownUI library, please see the [original repository](https://github.com/gonzalezreal/swift-markdown-ui).

![MarkdownDiff Example](Examples/Demo/diff.png)

## Usage

See [DiffView.swift](Examples/Demo/Demo/DiffView.swift) for examples on how to use MarkdownDiff.

## Installation

### Adding to an Xcode project

1. From the **File** menu, select **Add Packages…**
2. Enter `https://github.com/Jasonvdb/swift-markdown-diff` into the *Search or Enter Package URL* search field
3. Link **MarkdownUI** to your application target

### Adding to a Swift package

Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/Jasonvdb/swift-markdown-diff", from: "2.0.2")
```

Include `"MarkdownUI"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
  .product(name: "MarkdownUI", package: "swift-markdown-diff")
]),
```

Finally, add `import MarkdownUI` to your source code.
