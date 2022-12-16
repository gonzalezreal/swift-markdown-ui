import SwiftUI

extension Color {
  public init(rgba: UInt32) {
    self.init(
      red: CGFloat((rgba & 0xff00_0000) >> 24) / 255.0,
      green: CGFloat((rgba & 0x00ff_0000) >> 16) / 255.0,
      blue: CGFloat((rgba & 0x0000_ff00) >> 8) / 255.0,
      opacity: CGFloat(rgba & 0x0000_00ff) / 255.0
    )
  }

  public init(light: @escaping @autoclosure () -> Color, dark: @escaping @autoclosure () -> Color) {
    #if os(macOS)
      self.init(
        nsColor: .init(name: nil) { appearance in
          if appearance.bestMatch(from: [.aqua, .darkAqua]) == .aqua {
            return NSColor(light())
          } else {
            return NSColor(dark())
          }
        }
      )
    #elseif os(iOS) || os(tvOS)
      self.init(
        uiColor: .init { traitCollection in
          switch traitCollection.userInterfaceStyle {
          case .unspecified, .light:
            return UIColor(light())
          case .dark:
            return UIColor(dark())
          @unknown default:
            return UIColor(light())
          }
        }
      )
    #elseif os(watchOS)
      self = dark()
    #endif
  }
}
