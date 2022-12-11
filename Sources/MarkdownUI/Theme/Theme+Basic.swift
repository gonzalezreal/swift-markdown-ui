import SwiftUI

extension Theme {
  public static let basic = Theme(
    code: .monospaced(size: .em(0.94)),
    heading1: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownFontStyle { $0.bold().size(.em(2)) }
    },
    heading2: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownFontStyle { $0.bold().size(.em(1.5)) }
    },
    heading3: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownFontStyle { $0.bold().size(.em(1.17)) }
    },
    heading4: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownFontStyle { $0.bold().size(.em(1)) }
    },
    heading5: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownFontStyle { $0.bold().size(.em(0.83)) }
    },
    heading6: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownFontStyle { $0.bold().size(.em(0.67)) }
    },
    paragraph: BlockStyle { label in
      label
        .lineSpacing(.em(0.15))
        .markdownBlockSpacing(top: .zero, bottom: .em(1))
    },
    blockquote: BlockStyle { label in
      label
        .markdownFontStyle { $0.italic() }
        .padding(.leading, .em(2))
        .padding(.trailing, .em(1))
    },
    codeBlock: BlockStyle { label in
      label.markdownFontStyle { $0.monospaced().size(.em(0.94)) }
        .padding(.leading, .em(1))
        .lineSpacing(.em(0.15))
        .markdownBlockSpacing(top: .zero, bottom: .em(1))
    },
    taskListMarker: ListMarkerStyle { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
        .frame(minWidth: .em(1.5), alignment: .trailing)
    },
    table: BlockStyle { label in
      label.markdownBlockSpacing(top: .zero, bottom: .em(1))
    },
    tableBorder: TableBorderStyle(style: Color.secondary),
    tableCell: TableCellStyle { configuration in
      configuration.label
        .markdownFontStyle { configuration.row == 0 ? $0.bold() : $0 }
        .lineSpacing(.em(0.15))
        .padding(.horizontal, .em(0.72))
        .padding(.vertical, .em(0.35))
    },
    thematicBreak: BlockStyle { _ in
      Divider().markdownBlockSpacing(top: .em(2), bottom: .em(2))
    }
  )
}
