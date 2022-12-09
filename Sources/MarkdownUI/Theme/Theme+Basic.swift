import SwiftUI

extension Theme {
  public static let basic = Theme(
    code: .monospaced(size: .em(0.94)),
    blockquote: BlockStyle { label in
      label
        .markdownFontStyle { $0.italic() }
        .padding(.leading, .em(2))
        .padding(.trailing, .em(1))
    },
    taskListMarker: ListMarkerStyle { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
        .frame(minWidth: .em(1.5), alignment: .trailing)
    },
    codeBlock: BlockStyle { label in
      label.markdownFontStyle { $0.monospaced().size(.em(0.94)) }
        .padding(.leading, .em(1))
        .lineSpacing(.em(0.15))
    },
    paragraph: BlockStyle { $0.lineSpacing(.em(0.15)) },
    headings: [
      BlockStyle { label in
        label
          .markdownFontStyle { $0.bold().size(.em(2)) }
          .markdownBlockSpacing(top: .rem(1.5))
      },
      BlockStyle { label in
        label
          .markdownFontStyle { $0.bold().size(.em(1.5)) }
          .markdownBlockSpacing(top: .rem(1.5))
      },
      BlockStyle { label in
        label
          .markdownFontStyle { $0.bold().size(.em(1.17)) }
          .markdownBlockSpacing(top: .rem(1.5))
      },
      BlockStyle { label in
        label
          .markdownFontStyle { $0.bold().size(.em(1)) }
          .markdownBlockSpacing(top: .rem(1.5))
      },
      BlockStyle { label in
        label
          .markdownFontStyle { $0.bold().size(.em(0.83)) }
          .markdownBlockSpacing(top: .rem(1.5))
      },
      BlockStyle { label in
        label
          .markdownFontStyle { $0.bold().size(.em(0.67)) }
          .markdownBlockSpacing(top: .rem(1.5))
      },
    ],
    table: .unit,
    tableBorder: TableBorderStyle(style: Color.secondary),
    tableCell: TableCellStyle { configuration in
      configuration.label
        .markdownFontStyle { configuration.row == 0 ? $0.bold() : $0 }
        .lineSpacing(.em(0.15))
        .padding(.horizontal, .em(0.72))
        .padding(.vertical, .em(0.35))
    },
    tableCellBackground: .clear,
    thematicBreak: BlockStyle { _ in
      Divider().markdownBlockSpacing(top: .rem(2), bottom: .rem(2))
    }
  )
}
