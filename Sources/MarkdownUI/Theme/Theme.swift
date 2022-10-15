import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat

  // MARK: - Inline styles

  public var baseFont: Font

  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle
}

extension Theme {
  private enum Defaults {
    static let paragraphSpacing = Font.TextStyle.body.pointSize
  }

  public init(
    paragraphSpacing: CGFloat? = nil,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle
  ) {
    self.paragraphSpacing = paragraphSpacing ?? Defaults.paragraphSpacing
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
  }
}

extension Theme {
  public static var basic: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default
    )
  }
}
