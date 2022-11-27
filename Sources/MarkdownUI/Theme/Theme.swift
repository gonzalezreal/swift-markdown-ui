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
  public var imageFlowSpacing: GridSpacing
  public var blockquote: BlockStyle
  public var list: BlockStyle
  public var listItem: BlockStyle
  public var taskListMarker: ListMarkerStyle<TaskListItemConfiguration>
  public var bulletedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var numberedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var codeBlock: BlockStyle
  public var paragraph: BlockStyle
  public var headings: [BlockStyle] {
    willSet {
      precondition(newValue.count == 6, "A theme must have six heading styles.")
    }
  }
  public var table: BlockStyle
  public var tableBorder: TableBorderStyle
  public var tableCell: TableCellStyle
  public var tableCellBackground: TableCellBackgroundStyle
  public var thematicBreak: BlockStyle

  public init(
    baseFont: Font = .body,
    code: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: BlockStyle,
    imageFlowSpacing: GridSpacing = .defaultImageFlow,
    blockquote: BlockStyle,
    list: BlockStyle = .default,
    listItem: BlockStyle = .default,
    taskListMarker: ListMarkerStyle<TaskListItemConfiguration>,
    bulletedListMarker: ListMarkerStyle<ListItemConfiguration>,
    numberedListMarker: ListMarkerStyle<ListItemConfiguration>,
    codeBlock: BlockStyle,
    paragraph: BlockStyle = .default,
    headings: [BlockStyle],
    table: BlockStyle = .default,
    tableBorder: TableBorderStyle = .default,
    tableCell: TableCellStyle = .default,
    tableCellBackground: TableCellBackgroundStyle = .default,
    thematicBreak: BlockStyle
  ) {
    self.baseFont = baseFont
    self.code = code
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.imageFlowSpacing = imageFlowSpacing
    self.blockquote = blockquote
    self.list = list
    self.listItem = listItem
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
    self.codeBlock = codeBlock
    self.paragraph = paragraph
    precondition(headings.count == 6, "A theme must have six heading styles.")
    self.headings = headings
    self.table = table
    self.tableBorder = tableBorder
    self.tableCell = tableCell
    self.tableCellBackground = tableCellBackground
    self.thematicBreak = thematicBreak
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
      image: .defaultImage,
      blockquote: .defaultBlockquote,
      taskListMarker: .checkmarkSquareFill,
      bulletedListMarker: .discCircleSquare,
      numberedListMarker: .decimal,
      codeBlock: .defaultCodeBlock,
      headings: [
        .defaultHeading1,
        .defaultHeading2,
        .defaultHeading3,
        .defaultHeading4,
        .defaultHeading5,
        .defaultHeading6,
      ],
      thematicBreak: .defaultThematicBreak
    )
  }
}
