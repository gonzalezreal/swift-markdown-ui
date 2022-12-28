import SwiftUI

public struct Old_Theme {
  // MARK: - Colors

  public var textColor: Color?
  public var backgroundColor: Color?

  // MARK: - Inlines

  public var font: Old_FontStyle
  public var code: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle

  // MARK: - Blocks

  var headings: [Old_BlockStyle]
  public var paragraph: Old_BlockStyle
  public var blockquote: Old_BlockStyle
  public var codeBlock: Old_BlockStyle
  public var image: Old_BlockStyle
  public var list: Old_BlockStyle
  public var listItem: Old_BlockStyle
  public var taskListMarker: ListMarkerStyle<TaskListItemConfiguration>
  public var bulletedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var numberedListMarker: ListMarkerStyle<ListItemConfiguration>
  public var table: Old_BlockStyle
  public var tableBorder: TableBorderStyle
  public var tableCell: Old_TableCellStyle
  public var tableCellBackground: TableCellBackgroundStyle
  public var thematicBreak: Old_BlockStyle

  public init(
    textColor: Color? = nil,
    backgroundColor: Color? = nil,
    font: Old_FontStyle = .body,
    code: InlineStyle = .monospaced(),
    emphasis: InlineStyle = .italic,
    strong: InlineStyle = .bold,
    strikethrough: InlineStyle = .strikethrough,
    link: InlineStyle = .unit,
    heading1: Old_BlockStyle,
    heading2: Old_BlockStyle,
    heading3: Old_BlockStyle,
    heading4: Old_BlockStyle,
    heading5: Old_BlockStyle,
    heading6: Old_BlockStyle,
    paragraph: Old_BlockStyle,
    blockquote: Old_BlockStyle,
    codeBlock: Old_BlockStyle,
    image: Old_BlockStyle = .unit,
    list: Old_BlockStyle = .unit,
    listItem: Old_BlockStyle = .unit,
    taskListMarker: ListMarkerStyle<TaskListItemConfiguration>,
    bulletedListMarker: ListMarkerStyle<ListItemConfiguration> = .discCircleSquare,
    numberedListMarker: ListMarkerStyle<ListItemConfiguration> = .decimal,
    table: Old_BlockStyle,
    tableBorder: TableBorderStyle,
    tableCell: Old_TableCellStyle,
    tableCellBackground: TableCellBackgroundStyle = .clear,
    thematicBreak: Old_BlockStyle
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

extension Old_Theme {
  public var heading1: Old_BlockStyle {
    get { self.headings[0] }
    set { self.headings[0] = newValue }
  }

  public var heading2: Old_BlockStyle {
    get { self.headings[1] }
    set { self.headings[1] = newValue }
  }

  public var heading3: Old_BlockStyle {
    get { self.headings[2] }
    set { self.headings[2] = newValue }
  }

  public var heading4: Old_BlockStyle {
    get { self.headings[3] }
    set { self.headings[3] = newValue }
  }

  public var heading5: Old_BlockStyle {
    get { self.headings[4] }
    set { self.headings[4] = newValue }
  }

  public var heading6: Old_BlockStyle {
    get { self.headings[5] }
    set { self.headings[5] = newValue }
  }
}
