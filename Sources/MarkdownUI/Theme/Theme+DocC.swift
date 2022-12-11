import SwiftUI

extension Theme {
  public static let docC = Theme(
    foregroundColor: Color.text,
    backgroundColor: Color.background,
    link: InlineStyle { attributes in
      attributes.foregroundColor = .link
    },
    heading1: BlockStyle { label in
      label
        .markdownBlockSpacing(top: .em(0.8), bottom: .zero)
        .markdownFontStyle { $0.bold().size(.em(2)) }
    },
    heading2: BlockStyle { label in
      label
        .lineSpacing(.em(0.0625))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownFontStyle { $0.bold().size(.em(1.88235)) }
    },
    heading3: BlockStyle { label in
      label
        .lineSpacing(.em(0.07143))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownFontStyle { $0.bold().size(.em(1.64706)) }
    },
    heading4: BlockStyle { label in
      label
        .lineSpacing(.em(0.083335))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownFontStyle { $0.bold().size(.em(1.41176)) }
    },
    heading5: BlockStyle { label in
      label
        .lineSpacing(.em(0.09091))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownFontStyle { $0.bold().size(.em(1.29412)) }
    },
    heading6: BlockStyle { label in
      label
        .lineSpacing(.em(0.235295))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownFontStyle { $0.bold() }
    },
    paragraph: BlockStyle { label in
      label
        .lineSpacing(.em(0.235295))
        .markdownBlockSpacing(top: .em(0.8), bottom: .zero)
    },
    blockquote: BlockStyle { label in
      label
        .padding(.all, .rem(0.94118))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.asideNoteBackground)
        .clipShape(.container)
        .overlay {
          RoundedRectangle.container
            .strokeBorder(Color.asideNoteBorder)
        }
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
    },
    codeBlock: BlockStyle { label in
      ScrollView(.horizontal) {
        label
          .markdownFontStyle { $0.monospaced().size(.rem(0.88235)) }
          .lineSpacing(.em(0.333335))
          .padding(.vertical, 8)
          .padding(.leading, 14)
      }
      .background(Color.codeBackground)
      .clipShape(.container)
      .markdownBlockSpacing(top: .em(0.8), bottom: .zero)
    },
    image: BlockStyle { label in
      label
        .frame(maxWidth: .infinity)
        .markdownBlockSpacing(top: .em(1.6), bottom: .em(1.6))
    },
    listItem: BlockStyle { label in
      label.markdownBlockSpacing(top: .em(0.8))
    },
    taskListMarker: ListMarkerStyle { _ in
      // DocC renders task lists as bullet lists
      Bullet.disc
        .frame(minWidth: .em(1.5), alignment: .trailing)
    },
    table: BlockStyle { label in
      label.markdownBlockSpacing(top: .em(1.6), bottom: .zero)
    },
    tableBorder: TableBorderStyle(.horizontalLines, style: Color.grid),
    tableCell: TableCellStyle { configuration in
      configuration.label
        .markdownFontStyle { configuration.row == 0 ? $0.bold() : $0 }
        .lineSpacing(.em(0.235295))
        .padding(.all, .rem(0.58824))
    },
    thematicBreak: BlockStyle { _ in
      Divider()
        .overlay(Color.grid)
        .markdownBlockSpacing(top: .em(2.35), bottom: .em(2.35))
    }
  )
}

extension Shape where Self == RoundedRectangle {
  fileprivate static var container: Self {
    .init(cornerRadius: 15, style: .continuous)
  }
}

extension Color {
  fileprivate static let text = Color(
    light: Color(rgba: 0x1d1d_1fff), dark: Color(rgba: 0xf5f5_f7ff)
  )
  fileprivate static let secondaryLabel = Color(
    light: Color(rgba: 0x6e6e_73ff), dark: Color(rgba: 0x8686_8bff)
  )
  fileprivate static let background = Color(light: .white, dark: .black)
  fileprivate static let link = Color(
    light: Color(rgba: 0x0066_ccff), dark: Color(rgba: 0x2997_ffff)
  )
  fileprivate static let asideNoteBackground = Color(
    light: Color(rgba: 0xf5f5_f7ff), dark: Color(rgba: 0x3232_32ff)
  )
  fileprivate static let asideNoteBorder = Color(
    light: Color(rgba: 0x6969_69ff), dark: Color(rgba: 0x9a9a_9eff)
  )
  fileprivate static let codeBackground = Color(
    light: Color(rgba: 0xf5f5_f7ff), dark: Color(rgba: 0x3333_36ff)
  )
  fileprivate static let grid = Color(
    light: Color(rgba: 0xd2d2_d7ff), dark: Color(rgba: 0x4242_45ff)
  )
}
