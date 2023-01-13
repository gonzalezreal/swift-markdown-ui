import SwiftUI

/// A type that applies a custom appearance to specific types of blocks in a ``Markdown`` view.
///
/// The styles of the different block types are brought together in a ``Theme``. You can customize
/// the style of a specific block type by using the `markdownTheme(_:_:)` modifier.
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
/// .markdownTheme(
///   \.blockquote,
///   BlockStyle { configuration in
///     label
///       .padding()
///       .markdownTextStyle {
///         FontCapsVariant(.lowercaseSmallCaps)
///         FontWeight(.semibold)
///         BackgroundColor(nil)
///       }
///       .overlay(alignment: .leading) {
///         Rectangle()
///           .fill(Color.teal)
///           .frame(width: 4)
///       }
///       .background(Color.teal.opacity(0.5))
///   }
/// )
/// ```
///
/// Alternatively, you can use the `markdownTheme(_:body:)` modifier, which provides better ergonomics
/// at the call site by directly taking the body closure.
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
/// .markdownTheme(\.blockquote) { configuration in
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
public struct BlockStyle<Configuration> {
  private let body: (Configuration) -> AnyView

  /// Creates a block style that customizes a block by applying the given body.
  /// - Parameter body: A view builder that returns the customized block.
  public init<Body: View>(@ViewBuilder body: @escaping (_ configuration: Configuration) -> Body) {
    self.body = { AnyView(body($0)) }
  }

  func makeBody(configuration: Configuration) -> AnyView {
    self.body(configuration)
  }
}

extension BlockStyle where Configuration == Void {
  /// Creates a block style for a block with no content, like a thematic break.
  /// - Parameter body: A view builder that returns the customized block.
  public init<Body: View>(@ViewBuilder body: @escaping () -> Body) {
    self.init { _ in
      body()
    }
  }
}
