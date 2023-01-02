import Foundation

/// A markdown table element.
///
/// A table is a grid of cells arranged in rows and columns.
///
/// You typically create tables from collections of data. The following example shows how to create a
/// two-column table from an array of a `Superhero` type.
///
/// ```swift
/// struct Superhero {
///   let name: String
///   let realName: String
/// }
///
/// let superheroes = [
///   Superhero(name: "Black Widow", realName: "Natalia Alianovna Romanova"),
///   Superhero(name: "Moondragon", realName: "Heather Douglas"),
///   Superhero(name: "Invisible Woman", realName: "Susan Storm Richards"),
///   Superhero(name: "She-Hulk", realName: "Jennifer Walters"),
/// ]
///
/// var body: some View {
///   Markdown {
///     Table(superheroes) {
///       TableColumn(title: "Name", value: \.name)
///       TableColumn(title: "Real Name", value: \.realName)
///     }
///   }
/// }
/// ```
///
/// ![](Table-Collection)
///
/// To create a table from static rows, you provide both the columns and the rows rather than the contents
/// of a collection of data.
///
/// ```swift
/// struct Savings {
///   let month: String
///   let amount: Decimal
/// }
///
/// var body: some View {
///   Markdown {
///     Table {
///       TableColumn(title: "Month", value: \.month)
///       TableColumn(alignment: .trailing, title: "Savings") { row in
///         row.amount.formatted(.currency(code: "USD"))
///       }
///     } rows: {
///       TableRow(Savings(month: "January", amount: 100))
///       TableRow(Savings(month: "February", amount: 80))
///     }
///   }
/// }
/// ```
///
/// ![](Table-Static)
public struct Table: MarkdownContentProtocol {
  public var _markdownContent: MarkdownContent {
    .init(blocks: [.table(columnAlignments: self.columnAlignments, rows: self.rows)])
  }

  private let columnAlignments: [TableColumnAlignment?]
  private let rows: [[[Inline]]]

  init(columnAlignments: [TableColumnAlignment?], rows: [[[Inline]]]) {
    self.columnAlignments = columnAlignments
    self.rows = rows
  }

  /// Creates a table with the given columns and rows.
  /// - Parameters:
  ///   - columns: The columns to display in the table.
  ///   - rows: The rows to display in the table.
  public init<Value>(
    @TableColumnBuilder<Value> columns: () -> [TableColumn<Value>],
    @TableRowBuilder<Value> rows: () -> [TableRow<Value>]
  ) {
    self.init(rows().map(\.value), columns: columns)
  }

  /// Creates a table that computes its rows from a collection of data.
  /// - Parameters:
  ///   - data: The data for computing the table rows.
  ///   - columns: The columns to display in the table.
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
