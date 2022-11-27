import Foundation

public struct Table: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.table(columnAlignments: self.columnAlignments, rows: self.rows)])
  }

  private let columnAlignments: [TableColumnAlignment?]
  private let rows: [[[Inline]]]

  init(columnAlignments: [TableColumnAlignment?], rows: [[[Inline]]]) {
    self.columnAlignments = columnAlignments
    self.rows = rows
  }

  public init<Value>(
    @TableColumnBuilder<Value> columns: () -> [TableColumn<Value>],
    @TableRowBuilder<Value> rows: () -> [TableRow<Value>]
  ) {
    self.init(rows().map(\.value), columns: columns)
  }

  public init<Data>(
    _ data: Data,
    @TableColumnBuilder<Data.Element> columns: () -> [TableColumn<Data.Element>]
  ) where Data: RandomAccessCollection {
    let tableColumns = columns()
    let headerRow = tableColumns.map(\.title.inlines)

    self.init(
      columnAlignments: tableColumns.map(\.alignment),
      rows: CollectionOfOne(headerRow)
        + data.map { value in
          tableColumns.map { column in
            column.content(value).inlines
          }
        }
    )
  }
}
