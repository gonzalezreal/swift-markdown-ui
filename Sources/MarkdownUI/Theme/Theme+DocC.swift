import SwiftUI

extension Theme {
  public static let docC = Theme(
    text: TextStyle {
      ForegroundColor(.text)
    },
    link: TextStyle {
      ForegroundColor(.link)
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
