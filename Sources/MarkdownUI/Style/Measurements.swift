import SwiftUI

extension MarkdownStyle {
  /// The measurements that the ``Markdown`` view applies to each of its elements.
  public struct Measurements: Hashable {
    /// The scale that the `Markdown` view applies to a code block or inline.
    ///
    /// The `Markdown` view computes the font size in a code block or inline
    /// by multiplying the current font size by this value.
    public var codeFontScale: CGFloat

    /// The head indentation size, relative to the base font size.
    public var headIndentStep: CGFloat

    /// The tail indentation size, relative to the base font size.
    public var tailIndentStep: CGFloat

    /// The distance between the bottom of a paragraph and the top of the next, relative to the base font size.
    public var paragraphSpacing: CGFloat

    /// The distance between a list marker and a list item, relative to the base font size.
    public var listMarkerSpacing: CGFloat

    /// The scale that the `Markdown` view applies to each heading level.
    public var headingScales: HeadingScales

    /// The distance between the bottom of a heading and the top of the next block, relative to the base font size.
    public var headingSpacing: CGFloat

    /// Creates a `Measurements` instance.
    /// - Parameters:
    ///   - codeFontScale: The scale that the `Markdown` view applies to a code block or inline. The default is `0.94`.
    ///   - headIndentStep: The head indentation size, relative to the base font size. The default is `1.97`.
    ///   - tailIndentStep: The tail indentation size, relative to the base font size. The default is `-1`.
    ///   - paragraphSpacing: The distance between the bottom of a paragraph and the top of the next,
    ///                       relative to the base font size. The default is `1`.
    ///   - listMarkerSpacing: The distance between a list marker and a list item, relative to the base font size.
    ///                        The default is `0.47`.
    ///   - headingScales: The scale that the `Markdown` view applies to each heading level.
    ///   - headingSpacing: The distance between the bottom of a heading and the top of the next block,
    ///                     relative to the base font size. The default is `0.67`.
    public init(
      codeFontScale: CGFloat = 0.94,
      headIndentStep: CGFloat = 1.97,
      tailIndentStep: CGFloat = -1,
      paragraphSpacing: CGFloat = 1,
      listMarkerSpacing: CGFloat = 0.47,
      headingScales: HeadingScales = .default,
      headingSpacing: CGFloat = 0.67
    ) {
      self.codeFontScale = codeFontScale
      self.headIndentStep = headIndentStep
      self.tailIndentStep = tailIndentStep
      self.paragraphSpacing = paragraphSpacing
      self.listMarkerSpacing = listMarkerSpacing
      self.headingScales = headingScales
      self.headingSpacing = headingSpacing
    }
  }
}
