import SwiftUI

extension Old_Theme {
  public static let gitHub = Old_Theme(
    textColor: .text,
    backgroundColor: .background,
    font: .system(size: 16),
    code: .monospaced(size: .em(0.85), backgroundColor: .secondaryBackground),
    strong: .weight(.semibold),
    link: .foregroundColor(.link),
    heading1: Old_BlockStyle { label in
      VStack(alignment: .leading, spacing: 0) {
        label
          .padding(.bottom, .em(0.3))
          .lineSpacing(.em(0.125))
          .markdownBlockSpacing(top: .points(24), bottom: .points(16))
          .markdownFontStyle { $0.weight(.semibold).size(.em(2)) }
        Divider().overlay(Color.divider)
      }
    },
    heading2: Old_BlockStyle { label in
      VStack(alignment: .leading, spacing: 0) {
        label
          .padding(.bottom, .em(0.3))
          .lineSpacing(.em(0.125))
          .markdownBlockSpacing(top: .points(24), bottom: .points(16))
          .markdownFontStyle { $0.weight(.semibold).size(.em(1.5)) }
        Divider().overlay(Color.divider)
      }
    },
    heading3: Old_BlockStyle { label in
      label
        .lineSpacing(.em(0.125))
        .markdownBlockSpacing(top: .points(24), bottom: .points(16))
        .markdownFontStyle { $0.weight(.semibold).size(.em(1.25)) }
    },
    heading4: Old_BlockStyle { label in
      label
        .lineSpacing(.em(0.125))
        .markdownBlockSpacing(top: .points(24), bottom: .points(16))
        .markdownFontStyle { $0.weight(.semibold) }
    },
    heading5: Old_BlockStyle { label in
      label
        .lineSpacing(.em(0.125))
        .markdownBlockSpacing(top: .points(24), bottom: .points(16))
        .markdownFontStyle { $0.weight(.semibold).size(.em(0.875)) }
    },
    heading6: Old_BlockStyle { label in
      label
        .lineSpacing(.em(0.125))
        .foregroundColor(.tertiaryText)
        .markdownBlockSpacing(top: .points(24), bottom: .points(16))
        .markdownFontStyle { $0.weight(.semibold).size(.em(0.85)) }
    },
    paragraph: Old_BlockStyle { label in
      label
        .lineSpacing(.em(0.25))
        .markdownBlockSpacing(top: .zero, bottom: .points(16))
    },
    blockquote: Old_BlockStyle { label in
      HStack(spacing: 0) {
        RoundedRectangle(cornerRadius: 6)
          .fill(Color.border)
          .frame(width: .em(0.2))
        label
          .foregroundColor(.secondaryText)
          .padding(.horizontal, .em(1))
      }
      .fixedSize(horizontal: false, vertical: true)
    },
    codeBlock: Old_BlockStyle { label in
      ScrollView(.horizontal) {
        label
          .lineSpacing(.em(0.225))
          .markdownFontStyle { $0.monospaced().size(.em(0.85)) }
          .padding(16)
      }
      .background(Color.secondaryBackground)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .markdownBlockSpacing(top: .zero, bottom: .points(16))
    },
    listItem: Old_BlockStyle { label in
      label.markdownBlockSpacing(top: .em(0.25))
    },
    taskListMarker: ListMarkerStyle { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color.checkbox, Color.checkboxBackground)
        .imageScale(.small)
        .frame(minWidth: .em(1.5), alignment: .trailing)
    },
    table: Old_BlockStyle { label in
      label.markdownBlockSpacing(top: .zero, bottom: .points(16))
    },
    tableBorder: TableBorderStyle(color: .border),
    tableCell: Old_TableCellStyle { configuration in
      configuration.label
        .padding(.vertical, 6)
        .padding(.horizontal, 13)
        .lineSpacing(.em(0.25))
        .markdownFontStyle { configuration.row == 0 ? $0.weight(.semibold) : $0 }
    },
    tableCellBackground: .alternatingRows(Color.background, Color.secondaryBackground),
    thematicBreak: Old_BlockStyle { _ in
      Divider()
        .frame(height: .em(0.25))
        .overlay(Color.border)
        .markdownBlockSpacing(top: .points(24), bottom: .points(24))
    }
  )
}

extension Color {
  fileprivate static let text = Color(
    light: Color(rgba: 0x0606_06ff), dark: Color(rgba: 0xfbfb_fcff)
  )
  fileprivate static let secondaryText = Color(
    light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x9294_a0ff)
  )
  fileprivate static let tertiaryText = Color(
    light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x6d70_7dff)
  )
  fileprivate static let background = Color(
    light: .white, dark: Color(rgba: 0x1819_1dff)
  )
  fileprivate static let secondaryBackground = Color(
    light: Color(rgba: 0xf7f7_f9ff), dark: Color(rgba: 0x2526_2aff)
  )
  fileprivate static let link = Color(
    light: Color(rgba: 0x2c65_cfff), dark: Color(rgba: 0x4c8e_f8ff)
  )
  fileprivate static let border = Color(
    light: Color(rgba: 0xe4e4_e8ff), dark: Color(rgba: 0x4244_4eff)
  )
  fileprivate static let divider = Color(
    light: Color(rgba: 0xd0d0_d3ff), dark: Color(rgba: 0x3334_38ff)
  )
  fileprivate static let checkbox = Color(rgba: 0xb9b9_bbff)
  fileprivate static let checkboxBackground = Color(rgba: 0xeeee_efff)
}
