import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat
  public var headingSpacing: CGFloat
  public var headingSpacingBefore: CGFloat
  public var horizontalImageSpacing: CGFloat
  public var verticalImageSpacing: CGFloat
  public var minListMarkerWidth: CGFloat

  // MARK: - Inline styles

  public var baseFont: Font

  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle
  public var image: ImageStyle

  // MARK: - Block styles

  public var blockquote: BlockquoteStyle
  public var taskListItem: TaskListItemStyle
  public var taskListMarker: TaskListMarkerStyle
  public var bulletedListMarker: ListMarkerStyle
  public var numberedListMarker: ListMarkerStyle

  public var heading1: HeadingStyle
  public var heading2: HeadingStyle
  public var heading3: HeadingStyle
  public var heading4: HeadingStyle
  public var heading5: HeadingStyle
  public var heading6: HeadingStyle
}

extension Theme {
  private enum Defaults {
    static let paragraphSpacing = Font.TextStyle.body.pointSize
    static let headingSpacing = Font.TextStyle.body.pointSize
    static let headingSpacingBefore = Font.TextStyle.body.pointSize / 2
    static let horizontalImageSpacing = floor(Font.TextStyle.body.pointSize / 4)
    static let verticalImageSpacing = floor(Font.TextStyle.body.pointSize / 4)
    static let minListMarkerWidth = Font.TextStyle.body.pointSize * 1.5
  }

  public init(
    paragraphSpacing: CGFloat? = nil,
    headingSpacing: CGFloat? = nil,
    headingSpacingBefore: CGFloat? = nil,
    horizontalImageSpacing: CGFloat? = nil,
    verticalImageSpacing: CGFloat? = nil,
    minListMarkerWidth: CGFloat? = nil,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: ImageStyle,
    blockquote: BlockquoteStyle,
    taskListItem: TaskListItemStyle,
    taskListMarker: TaskListMarkerStyle,
    bulletedListMarker: ListMarkerStyle,
    numberedListMarker: ListMarkerStyle,
    heading1: HeadingStyle,
    heading2: HeadingStyle,
    heading3: HeadingStyle,
    heading4: HeadingStyle,
    heading5: HeadingStyle,
    heading6: HeadingStyle
  ) {
    self.paragraphSpacing = paragraphSpacing ?? Defaults.paragraphSpacing
    self.headingSpacing = headingSpacing ?? Defaults.headingSpacing
    self.headingSpacingBefore = headingSpacingBefore ?? Defaults.headingSpacingBefore
    self.horizontalImageSpacing = horizontalImageSpacing ?? Defaults.horizontalImageSpacing
    self.verticalImageSpacing = verticalImageSpacing ?? Defaults.verticalImageSpacing
    self.minListMarkerWidth = minListMarkerWidth ?? Defaults.minListMarkerWidth
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.blockquote = blockquote
    self.taskListItem = taskListItem
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
    self.heading1 = heading1
    self.heading2 = heading2
    self.heading3 = heading3
    self.heading4 = heading4
    self.heading5 = heading5
    self.heading6 = heading6
  }
}

extension Theme {
  public static var `default`: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      image: .default,
      blockquote: .indentItalic,
      taskListItem: .default,
      taskListMarker: .checkmarkSquareFill,
      bulletedListMarker: .discCircleSquare,
      numberedListMarker: .decimal,
      heading1: .font(.largeTitle.weight(.medium)),
      heading2: .font(.title.weight(.medium)),
      heading3: .font(.title2.weight(.medium)),
      heading4: .font(.title3.weight(.medium)),
      heading5: .font(.headline),
      heading6: .font(.subheadline.weight(.medium))
    )
  }
}
