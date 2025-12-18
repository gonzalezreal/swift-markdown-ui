# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

```bash
# Build the package
swift build

# Run all tests (requires iOS simulator - tests are iOS-only snapshot tests)
swift test

# Run a specific test
swift test --filter MarkdownUITests.MarkdownTests/testBlockquote
```

Note: Tests use SnapshotTesting and only run on iOS (they are skipped on Mac Catalyst/iPad). The test snapshots are stored in `Tests/MarkdownUITests/__Snapshots__/`.

## Architecture Overview

MarkdownUI is a SwiftUI library for rendering GitHub Flavored Markdown. The architecture follows a pipeline pattern:

### Parsing Layer (`Sources/MarkdownUI/Parser/`)
- Uses `swift-cmark` (cmark-gfm) for Markdown parsing
- `MarkdownParser.swift` contains the core parsing logic using `UnsafeNode` wrapper around cmark's C API
- Parses into `BlockNode` and `InlineNode` enum types that represent the AST
- Supports GFM extensions: autolink, strikethrough, tables (iOS 16+), tasklists

### DSL Layer (`Sources/MarkdownUI/DSL/`)
- Provides Swift result builders for programmatic Markdown construction
- `MarkdownContentBuilder` for composing blocks (headings, paragraphs, lists, etc.)
- `InlineContentBuilder` for composing inline elements (text, links, emphasis, etc.)
- Allows mixing raw Markdown strings with typed DSL elements

### Theme System (`Sources/MarkdownUI/Theme/`)
- `Theme` struct contains all text and block styles
- Built-in themes: `.basic` (default), `.gitHub`, `.docC`
- `TextStyle` protocol with composable text styling (font, color, etc.)
- `BlockStyle` for block-level styling (margins, backgrounds, etc.)
- Styles are applied via SwiftUI environment and modifiers

### View Layer (`Sources/MarkdownUI/Views/`)
- `Markdown` is the main public view
- `BlockNode+View.swift` maps AST nodes to SwiftUI views
- Each block type has a corresponding view (e.g., `BlockquoteView`, `CodeBlockView`)
- `BlockSequence` handles rendering a list of blocks with proper margins

### Extensibility (`Sources/MarkdownUI/Extensibility/`)
- `ImageProvider` protocol for custom image loading
- `InlineImageProvider` for inline images within text
- `CodeSyntaxHighlighter` protocol for code block syntax highlighting

## Key Patterns

- The `Markdown` view accepts content via string, `MarkdownContent` (pre-parsed), or result builder
- Theme customization uses SwiftUI modifiers: `.markdownTheme()`, `.markdownTextStyle()`, `.markdownBlockStyle()`
- The library uses `NetworkImage` dependency for async image loading
- Tables require iOS 16+/macOS 13+ and use native SwiftUI Grid
