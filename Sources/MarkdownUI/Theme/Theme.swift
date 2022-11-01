import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var minListMarkerWidth: CGFloat

  // MARK: - Inline styles

  public var baseFont: Font
  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle

  // MARK: - Block styles

  public var image: BlockStyle
  public var blockquote: BlockStyle
  public var taskListItem: TaskListItemStyle
  public var taskListMarker: TaskListMarkerStyle
  public var bulletedListMarker: ListMarkerStyle
  public var numberedListMarker: ListMarkerStyle
  public var paragraph: BlockStyle
  public var headings: [BlockStyle] {
    willSet {
      precondition(newValue.count > 0, "A theme must have at least one heading style.")
    }
  }
}

extension Theme {
  private enum Defaults {
    static let minListMarkerWidth = Font.TextStyle.body.pointSize * 1.5
  }

  public init(
    minListMarkerWidth: CGFloat? = nil,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: BlockStyle,
    blockquote: BlockStyle,
    taskListItem: TaskListItemStyle,
    taskListMarker: TaskListMarkerStyle,
    bulletedListMarker: ListMarkerStyle,
    numberedListMarker: ListMarkerStyle,
    paragraph: BlockStyle,
    headings: [BlockStyle]
  ) {
    self.minListMarkerWidth = minListMarkerWidth ?? Defaults.minListMarkerWidth
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.paragraph = paragraph
    self.blockquote = blockquote
    self.taskListItem = taskListItem
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
    precondition(headings.count > 0, "A theme must have at least one heading style.")
    self.headings = headings
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
      image: .defaultImage(),
      blockquote: .defaultBlockquote(),
      taskListItem: .default,
      taskListMarker: .checkmarkSquareFill,
      bulletedListMarker: .discCircleSquare,
      numberedListMarker: .decimal,
      paragraph: .defaultParagraph(),
      headings: [
        .defaultHeading(font: .largeTitle.weight(.medium)),
        .defaultHeading(font: .title.weight(.medium)),
        .defaultHeading(font: .title2.weight(.medium)),
        .defaultHeading(font: .title3.weight(.medium)),
        .defaultHeading(font: .headline),
        .defaultHeading(font: .subheadline.weight(.medium)),
      ]
    )
  }
}
