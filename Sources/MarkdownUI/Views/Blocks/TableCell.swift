import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct TableCell: View {
  private let row: Int
  private let column: Int
  private let inlines: [Inline]

  init(row: Int, column: Int, inlines: [Inline]) {
    self.row = row
    self.column = column
    self.inlines = inlines
  }

  var body: some View {
    ApplyBlockStyle(
      \.tableCell,
      configuration: .init(
        row: self.row,
        column: self.column,
        label: .init(self.content)
      )
    )
    .tableCellBounds(forRow: self.row, column: self.column)
  }

  @ViewBuilder private var content: some View {
    if let imageFlow = ImageFlow(self.inlines) {
      imageFlow
    } else {
      InlineText(self.inlines)
    }
  }
}
