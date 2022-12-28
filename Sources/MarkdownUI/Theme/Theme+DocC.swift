import SwiftUI

extension Theme {
  public static let docC = Theme()
    .text {
      ForegroundColor(.text)
    }
    .link {
      ForegroundColor(.link)
    }
    .heading1 { label in
      label
        .markdownBlockSpacing(top: .em(0.8), bottom: .zero)
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(2))
        }
    }
    .heading2 { label in
      label
        .lineSpacing(.em(0.0625))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1.88235))
        }
    }
    .heading3 { label in
      label
        .lineSpacing(.em(0.07143))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1.64706))
        }
    }
    .heading4 { label in
      label
        .lineSpacing(.em(0.083335))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1.41176))
        }
    }
    .heading5 { label in
      label
        .lineSpacing(.em(0.09091))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1.29412))
        }
    }
    .heading6 { label in
      label
        .lineSpacing(.em(0.235295))
        .markdownBlockSpacing(top: .em(1.6), bottom: .zero)
        .markdownTextStyle {
          FontWeight(.bold)
        }
    }
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
