import SwiftUI

enum DocC {
  enum Colors {
    static let secondaryBackground = Color(
      light: .init(rgbaValue: 0xf5_f5_f7_ff),
      dark: .init(rgbaValue: 0x32_32_32_ff)
    )

    static let asideNoteBackground = secondaryBackground

    static let asideNoteBorder = Color(
      light: .init(rgbaValue: 0x69_69_69_ff),
      dark: .init(rgbaValue: 0x9a_9a_9e_ff)
    )
  }

  enum Shapes {
    static let container = RoundedRectangle(cornerRadius: 15, style: .continuous)
  }
}
