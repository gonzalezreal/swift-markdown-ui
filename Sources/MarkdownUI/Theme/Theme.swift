import SwiftUI

public struct Theme {
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
  public var taskListMarker: ListMarkerStyle<TaskListItemConfiguration>
  public var bulletedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var numberedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var paragraph: BlockStyle
  public var headings: [BlockStyle] {
    willSet {
      precondition(newValue.count > 0, "A theme must have at least one heading style.")
    }
  }

  public init(
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: BlockStyle,
    blockquote: BlockStyle,
    taskListMarker: ListMarkerStyle<TaskListItemConfiguration>,
    bulletedListMarker: ListMarkerStyle<ListItemConfiguration>,
    numberedListMarker: ListMarkerStyle<ListItemConfiguration>,
    paragraph: BlockStyle,
    headings: [BlockStyle]
  ) {
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.blockquote = blockquote
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
    self.paragraph = paragraph
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
