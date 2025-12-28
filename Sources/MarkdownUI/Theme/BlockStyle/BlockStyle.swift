import SwiftUI

/// A type that applies a custom appearance to specific types of blocks in a Markdown view.
///
/// The styles of the different block types are brought together in a ``Theme``. You can customize
/// the style of a specific block type by using the `markdownBlockStyle(_:body:)` modifier.
///
/// The following example applies a custom appearance to each ``Theme/blockquote`` in
/// a ``Markdown`` view:
///
/// ```swift
/// Markdown {
///   """
///   You can quote text with a `>`.
///
///   > Outside of a dog, a book is man's best friend. Inside of a
///   > dog it's too dark to read.
///
///   – Groucho Marx
///   """
/// }
/// .markdownBlockStyle(\.blockquote) { configuration in
///   configuration.label
///     .padding()
///     .markdownTextStyle {
///       FontCapsVariant(.lowercaseSmallCaps)
///       FontWeight(.semibold)
///       BackgroundColor(nil)
///     }
///     .overlay(alignment: .leading) {
///       Rectangle()
///         .fill(Color.teal)
///         .frame(width: 4)
///     }
///     .background(Color.teal.opacity(0.5))
/// }
/// ```
///
/// ![](CustomBlockquote)
public struct BlockStyle<Configuration>: @unchecked Sendable {
  private let body: @Sendable @MainActor (Configuration) -> AnyView

  /// Creates a block style that customizes a block by applying the given body.
  /// - Parameter body: A view builder that returns the customized block.
  public init<Body: View>(@ViewBuilder body: @escaping @Sendable @MainActor (_ configuration: Configuration) -> Body) {
    self.body = { @Sendable @MainActor in AnyView(body($0)) }
  }

  @MainActor func makeBody(configuration: Configuration) -> AnyView {
    self.body(configuration)
  }
}

extension BlockStyle where Configuration == Void {
  /// Creates a block style for a block with no content, like a thematic break.
  /// - Parameter body: A view builder that returns the customized block.
  public init<Body: View>(@ViewBuilder body: @escaping @Sendable @MainActor () -> Body) {
    self.init { @Sendable @MainActor _ in
      body()
    }
  }
}
