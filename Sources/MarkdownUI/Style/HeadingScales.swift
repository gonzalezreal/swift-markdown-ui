import SwiftUI

extension MarkdownStyle {
  /// The scale that the ``Markdown`` view applies to each heading level.
  ///
  /// You use a `HeadingScales` instance to configure the heading sizes in
  /// a `Markdown` view. When the `Markdown` view encounters a heading,
  /// it computes the font size by multiplying the base font size by the scale
  /// specified for that heading level.
  public struct HeadingScales: Hashable {
    private var values: [CGFloat]

    /// Creates a `HeadingScales` instance with the provided scales for each
    /// heading level.
    public init(
      h1: CGFloat,
      h2: CGFloat,
      h3: CGFloat,
      h4: CGFloat,
      h5: CGFloat,
      h6: CGFloat
    ) {
      self.values = [h1, h2, h3, h4, h5, h6]
    }

    public subscript(index: Int) -> CGFloat {
      values[index]
    }

    /// The default heading scales.
    public static let `default` = Self(h1: 2, h2: 1.5, h3: 1.17, h4: 1, h5: 0.83, h6: 0.67)
  }
}
