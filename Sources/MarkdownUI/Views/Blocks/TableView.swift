import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct TableView: View {
  @Environment(\.tableBorderStyle.strokeStyle.lineWidth) private var borderWidth

  private let columnAlignments: [HorizontalAlignment]
  private let rows: [[[Inline]]]

  init(columnAlignments: [TextTableColumnAlignment?], rows: [[[Inline]]]) {
    self.columnAlignments = columnAlignments.map(HorizontalAlignment.init)
    self.rows = rows
  }

  var body: some View {
    Grid(horizontalSpacing: self.borderWidth, verticalSpacing: self.borderWidth) {
      ForEach(0..<self.rowCount, id: \.self) { row in
        GridRow {
          ForEach(0..<self.columnCount, id: \.self) { column in
            TableCell(row: row, column: column, inlines: self.rows[row][column])
              .gridColumnAlignment(self.columnAlignments[column])
          }
        }
      }
    }
    .padding(self.borderWidth)
    .tableDecoration(
      rowCount: self.rowCount,
      columnCount: self.columnCount,
      background: TableBackgroundView.init,
      overlay: TableBorderView.init
    )
  }

  private var rowCount: Int {
    self.rows.count
  }

  private var columnCount: Int {
    self.columnAlignments.count
  }
}

extension HorizontalAlignment {
  fileprivate init(_ tableColumnAlignment: TextTableColumnAlignment?) {
    switch tableColumnAlignment {
    case .none, .leading:
      self = .leading
    case .center:
      self = .center
    case .trailing:
      self = .trailing
    }
  }
}
