import SwiftUI

extension MarkdownStyle {
  public struct Measurements {
    public var codeFontScale: CGFloat
    public var headIndentStep: CGFloat
    public var tailIndentStep: CGFloat
    public var paragraphSpacing: CGFloat
    public var listMarkerSpacing: CGFloat
    public var headingScale: (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)
    public var headingSpacing: CGFloat

    public static let defaults = Measurements(
      codeFontScale: 0.94,
      headIndentStep: 1.97,
      tailIndentStep: -1,
      paragraphSpacing: 1,
      listMarkerSpacing: 0.47,
      headingScale: (2, 1.5, 1.17, 1, 0.83, 0.67),
      headingSpacing: 0.67
    )

    public init(
      codeFontScale: CGFloat = defaults.codeFontScale,
      headIndentStep: CGFloat = defaults.headIndentStep,
      tailIndentStep: CGFloat = defaults.tailIndentStep,
      paragraphSpacing: CGFloat = defaults.paragraphSpacing,
      listMarkerSpacing: CGFloat = defaults.listMarkerSpacing,
      headingScale: (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) = defaults.headingScale,
      headingSpacing: CGFloat = defaults.headingSpacing
    ) {
      self.codeFontScale = codeFontScale
      self.headIndentStep = headIndentStep
      self.tailIndentStep = tailIndentStep
      self.paragraphSpacing = paragraphSpacing
      self.listMarkerSpacing = listMarkerSpacing
      self.headingScale = headingScale
      self.headingSpacing = headingSpacing
    }
  }
}
