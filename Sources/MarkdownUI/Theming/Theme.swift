import SwiftUI

extension Markdown {
  public struct Theme {
    // MARK: - Metrics

    public var spacing: CGFloat?
    public var indentSize: CGFloat

    // MARK: - Inline styles

    public var inlineCode: InlineStyle
    public var emphasis: InlineStyle
    public var strong: InlineStyle
    public var strikethrough: InlineStyle
    public var link: InlineStyle
  }
}
