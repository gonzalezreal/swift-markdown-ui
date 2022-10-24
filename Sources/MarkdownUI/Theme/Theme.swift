import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat
  public var horizontalImageSpacing: CGFloat
  public var verticalImageSpacing: CGFloat

  // MARK: - Inline styles

  public var baseFont: Font

  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle
  public var image: ImageStyle
}

extension Theme {
  private enum Defaults {
    static let paragraphSpacing = Font.TextStyle.body.pointSize
    static let horizontalImageSpacing = floor(Font.TextStyle.body.pointSize / 4)
    static let verticalImageSpacing = floor(Font.TextStyle.body.pointSize / 4)
  }

  public init(
    paragraphSpacing: CGFloat? = nil,
    horizontalImageSpacing: CGFloat? = nil,
    verticalImageSpacing: CGFloat? = nil,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: ImageStyle
  ) {
    self.paragraphSpacing = paragraphSpacing ?? Defaults.paragraphSpacing
    self.horizontalImageSpacing = horizontalImageSpacing ?? Defaults.horizontalImageSpacing
    self.verticalImageSpacing = verticalImageSpacing ?? Defaults.verticalImageSpacing
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
  }
}

extension Theme {
  public static var basic: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      image: .default
    )
  }
}
