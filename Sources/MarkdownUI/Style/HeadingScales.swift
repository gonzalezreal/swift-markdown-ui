import SwiftUI

extension MarkdownStyle {
  public struct HeadingScales: Hashable {
    private var values: [CGFloat]

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

    public static let `default` = Self(h1: 2, h2: 1.5, h3: 1.17, h4: 1, h5: 0.83, h6: 0.67)
  }
}
