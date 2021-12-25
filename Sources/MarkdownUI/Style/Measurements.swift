import SwiftUI

extension MarkdownStyle {
  public struct Measurements: Hashable {
    public var codeFontScale: CGFloat
    public var headIndentStep: CGFloat
    public var tailIndentStep: CGFloat
    public var paragraphSpacing: CGFloat
    public var listMarkerSpacing: CGFloat
    public var headingScales: HeadingScales
    public var headingSpacing: CGFloat

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
