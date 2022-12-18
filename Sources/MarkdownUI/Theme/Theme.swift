import SwiftUI

public struct Theme {
  // MARK: - Colors

  public var textColor: Color?
  public var backgroundColor: Color?

  // MARK: - Inlines

  public var font: FontStyle
  public var code: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle

  // MARK: - Blocks

  var headings: [BlockStyle]
  public var paragraph: BlockStyle
  public var blockquote: BlockStyle
  public var codeBlock: BlockStyle
  public var image: BlockStyle
  public var list: BlockStyle
  public var listItem: BlockStyle
  public var taskListMarker: ListMarkerStyle<TaskListItemConfiguration>
  public var bulletedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var numberedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var table: BlockStyle
  public var tableBorder: TableBorderStyle
  public var tableCell: TableCellStyle
  public var tableCellBackground: TableCellBackgroundStyle
  public var thematicBreak: BlockStyle

  public init(
    textColor: Color? = nil,
    backgroundColor: Color? = nil,
    font: FontStyle = .body,
    code: InlineStyle = .monospaced(),
    emphasis: InlineStyle = .italic,
    strong: InlineStyle = .bold,
    strikethrough: InlineStyle = .strikethrough,
    link: InlineStyle = .unit,
    heading1: BlockStyle,
    heading2: BlockStyle,
    heading3: BlockStyle,
    heading4: BlockStyle,
    heading5: BlockStyle,
    heading6: BlockStyle,
    paragraph: BlockStyle,
    blockquote: BlockStyle,
    codeBlock: BlockStyle,
    image: BlockStyle = .unit,
    list: BlockStyle = .unit,
    listItem: BlockStyle = .unit,
    taskListMarker: ListMarkerStyle<TaskListItemConfiguration>,
    bulletedListMarker: ListMarkerStyle<ListItemConfiguration> = .discCircleSquare,
    numberedListMarker: ListMarkerStyle<ListItemConfiguration> = .decimal,
    table: BlockStyle,
    tableBorder: TableBorderStyle,
    tableCell: TableCellStyle,
    tableCellBackground: TableCellBackgroundStyle = .clear,
    thematicBreak: BlockStyle
  ) {
    self.textColor = textColor
    self.backgroundColor = backgroundColor

    self.font = font
    self.code = code
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link

    self.headings = [heading1, heading2, heading3, heading4, heading5, heading6]
    self.paragraph = paragraph
    self.blockquote = blockquote
    self.codeBlock = codeBlock
    self.image = image
    self.list = list
    self.listItem = listItem
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
    self.table = table
    self.tableBorder = tableBorder
    self.tableCell = tableCell
    self.tableCellBackground = tableCellBackground
    self.thematicBreak = thematicBreak
  }
}

// MARK: - Headings

extension Theme {
  public var heading1: BlockStyle {
    get { self.headings[0] }
    set { self.headings[0] = newValue }
  }

  public var heading2: BlockStyle {
    get { self.headings[1] }
    set { self.headings[1] = newValue }
  }

  public var heading3: BlockStyle {
    get { self.headings[2] }
    set { self.headings[2] = newValue }
  }

  public var heading4: BlockStyle {
    get { self.headings[3] }
    set { self.headings[3] = newValue }
  }

  public var heading5: BlockStyle {
    get { self.headings[4] }
    set { self.headings[4] = newValue }
  }

  public var heading6: BlockStyle {
    get { self.headings[5] }
    set { self.headings[5] = newValue }
  }
}
