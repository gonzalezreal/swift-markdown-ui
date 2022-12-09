import SwiftUI

public struct Theme {
  // MARK: - Colors

  public var primary: Color
  public var secondary: Color
  public var background: Color

  // MARK: - Inlines

  public var font: FontStyle
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
  public var codeBlock: BlockStyle
  public var paragraph: BlockStyle
  public var headings: [BlockStyle] {
    willSet {
      precondition(newValue.count == 6, "A theme must provide 6 heading styles.")
    }
  }
  public var table: BlockStyle
  public var tableBorder: TableBorderStyle
  public var tableCell: TableCellStyle
  public var tableCellBackground: TableCellBackgroundStyle
  public var thematicBreak: BlockStyle

  public init(
    primary: Color = .primary,
    secondary: Color = .secondary,
    background: Color = .clear,
    font: FontStyle = .body,
    code: InlineStyle = .monospaced(),
    emphasis: InlineStyle = .italic,
    strong: InlineStyle = .bold,
    strikethrough: InlineStyle = .strikethrough,
    link: InlineStyle = .unit,
    image: BlockStyle = .unit,
    blockquote: BlockStyle,
    list: BlockStyle = .unit,
    listItem: BlockStyle = .unit,
    taskListMarker: ListMarkerStyle<TaskListItemConfiguration>,
    bulletedListMarker: ListMarkerStyle<ListItemConfiguration> = .discCircleSquare,
    numberedListMarker: ListMarkerStyle<ListItemConfiguration> = .decimal,
    codeBlock: BlockStyle,
    paragraph: BlockStyle,
    headings: [BlockStyle],
    table: BlockStyle = .unit,
    tableBorder: TableBorderStyle,
    tableCell: TableCellStyle,
    tableCellBackground: TableCellBackgroundStyle = .clear,
    thematicBreak: BlockStyle
  ) {
    precondition(headings.count == 6, "A theme must provide 6 heading styles.")

    self.primary = primary
    self.secondary = secondary
    self.background = background
    self.font = font
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
    self.codeBlock = codeBlock
    self.paragraph = paragraph
    self.headings = headings
    self.table = table
    self.tableBorder = tableBorder
    self.tableCell = tableCell
    self.tableCellBackground = tableCellBackground
    self.thematicBreak = thematicBreak
  }
}
