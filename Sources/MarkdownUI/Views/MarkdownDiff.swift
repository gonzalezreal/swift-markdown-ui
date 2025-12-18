import SwiftUI

/// A view that displays the visual diff between two Markdown strings.
///
/// `MarkdownDiff` shows deleted content with red strikethrough text
/// and added content with green text.
///
/// ```swift
/// MarkdownDiff(
///   old: "Hello world",
///   new: "Hello beautiful world"
/// )
/// ```
///
/// You can customize the appearance using the standard theme modifiers:
///
/// ```swift
/// MarkdownDiff(old: oldText, new: newText)
///   .markdownTheme(.gitHub)
///   .markdownTextStyle(\.diffInserted) {
///     ForegroundColor(.mint)
///   }
///   .markdownTextStyle(\.diffDeleted) {
///     ForegroundColor(.pink)
///     StrikethroughStyle(.single)
///   }
/// ```
public struct MarkdownDiff: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.theme.text) private var text

  private let content: MarkdownContent
  private let baseURL: URL?
  private let imageBaseURL: URL?

  /// Creates a MarkdownDiff view from two Markdown strings.
  /// - Parameters:
  ///   - old: The original Markdown string.
  ///   - new: The updated Markdown string.
  ///   - baseURL: The base URL to use when resolving Markdown URLs. If this value is `nil`, the initializer will consider all
  ///              URLs absolute. The default is `nil`.
  ///   - imageBaseURL: The base URL to use when resolving Markdown image URLs. If this value is `nil`, the initializer will
  ///                   determine image URLs using the `baseURL` parameter. The default is `nil`.
  public init(
    old: String,
    new: String,
    baseURL: URL? = nil,
    imageBaseURL: URL? = nil
  ) {
    let oldBlocks = Array<BlockNode>(markdown: old)
    let newBlocks = Array<BlockNode>(markdown: new)
    let diffedBlocks = BlockDiff.diff(old: oldBlocks, new: newBlocks)

    self.content = MarkdownContent(blocks: diffedBlocks)
    self.baseURL = baseURL
    self.imageBaseURL = imageBaseURL ?? baseURL
  }

  /// Creates a MarkdownDiff view from two MarkdownContent values.
  /// - Parameters:
  ///   - old: The original Markdown content.
  ///   - new: The updated Markdown content.
  ///   - baseURL: The base URL to use when resolving Markdown URLs. If this value is `nil`, the initializer will consider all
  ///              URLs absolute. The default is `nil`.
  ///   - imageBaseURL: The base URL to use when resolving Markdown image URLs. If this value is `nil`, the initializer will
  ///                   determine image URLs using the `baseURL` parameter. The default is `nil`.
  public init(
    old: MarkdownContent,
    new: MarkdownContent,
    baseURL: URL? = nil,
    imageBaseURL: URL? = nil
  ) {
    let diffedBlocks = BlockDiff.diff(old: old.blocks, new: new.blocks)

    self.content = MarkdownContent(blocks: diffedBlocks)
    self.baseURL = baseURL
    self.imageBaseURL = imageBaseURL ?? baseURL
  }

  public var body: some View {
    TextStyleAttributesReader { attributes in
      BlockSequence(self.blocks)
        .foregroundColor(attributes.foregroundColor)
        .background(attributes.backgroundColor)
        .modifier(ScaledFontSizeModifier(attributes.fontProperties?.size))
    }
    .textStyle(self.text)
    .environment(\.baseURL, self.baseURL)
    .environment(\.imageBaseURL, self.imageBaseURL)
  }

  private var blocks: [BlockNode] {
    self.content.blocks.filterImagesMatching(colorScheme: self.colorScheme)
  }
}

private struct ScaledFontSizeModifier: ViewModifier {
  @ScaledMetric private var size: CGFloat

  init(_ size: CGFloat?) {
    self._size = ScaledMetric(wrappedValue: size ?? FontProperties.defaultSize, relativeTo: .body)
  }

  func body(content: Content) -> some View {
    content.markdownTextStyle {
      FontSize(self.size)
    }
  }
}
