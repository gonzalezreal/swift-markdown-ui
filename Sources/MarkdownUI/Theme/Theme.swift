import SwiftUI

public struct Theme {
  // MARK: - Inlines

  public var baseFont: Font
  public var code: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle

  // MARK: - Blocks

  public var image: BlockStyle
  public var blockquote: BlockStyle
  public var list: BlockStyle
  public var listItem: BlockStyle
  public var taskListMarker: ListMarkerStyle<TaskListItemConfiguration>
  public var bulletedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var numberedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var paragraph: BlockStyle
  public var headings: [BlockStyle] {
    willSet {
      precondition(newValue.count == 6, "A theme must have six heading styles.")
    }
  }

  public init(
    baseFont: Font = .body,
    code: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: BlockStyle,
    blockquote: BlockStyle,
    list: BlockStyle = .default(),
    listItem: BlockStyle = .default(),
    taskListMarker: ListMarkerStyle<TaskListItemConfiguration>,
    bulletedListMarker: ListMarkerStyle<ListItemConfiguration>,
    numberedListMarker: ListMarkerStyle<ListItemConfiguration>,
    paragraph: BlockStyle = .default(),
    headings: [BlockStyle]
  ) {
    self.baseFont = baseFont
    self.code = code
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.blockquote = blockquote
    self.list = list
    self.listItem = listItem
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
    self.paragraph = paragraph
    precondition(headings.count == 6, "A theme must have six heading styles.")
    self.headings = headings
  }
}

extension Theme {
  public static var `default`: Self {
    .init(
      code: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      image: .defaultImage(),
      blockquote: .defaultBlockquote(),
      taskListMarker: .checkmarkSquareFill,
      bulletedListMarker: .discCircleSquare,
      numberedListMarker: .decimal,
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
