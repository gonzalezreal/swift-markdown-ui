import SwiftUI

extension MarkdownStyle {
  public struct Measurements {
    public var codeFontScale: CGFloat
    public var headIndentStep: CGFloat
    public var tailIndentStep: CGFloat
    public var paragraphSpacing: CGFloat

    public static let `default` = Measurements(
      codeFontScale: 0.94,
      headIndentStep: 1,
      tailIndentStep: -0.5,
      paragraphSpacing: 1
    )

    public init(
      codeFontScale: CGFloat,
      headIndentStep: CGFloat,
      tailIndentStep: CGFloat,
      paragraphSpacing: CGFloat
    ) {
      self.codeFontScale = codeFontScale
      self.headIndentStep = headIndentStep
      self.tailIndentStep = tailIndentStep
      self.paragraphSpacing = paragraphSpacing
    }
  }
}
