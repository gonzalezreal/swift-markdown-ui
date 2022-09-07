import SwiftUI

extension Color {
  public init(rgbaValue: UInt32) {
    let components = RGBAComponents(rgbaValue: rgbaValue).normalized
    self.init(red: components[0], green: components[1], blue: components[2], opacity: components[3])
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
    #endif
  }
}

private struct RGBAComponents {
  let rgbaValue: UInt32

  private var shifts: [UInt32] {
    [
      rgbaValue >> 24,  // red
      rgbaValue >> 16,  // green
      rgbaValue >> 8,  // blue
      rgbaValue,  // alpha
    ]
  }

  private var components: [CGFloat] {
    shifts.map { CGFloat($0 & 0xff) }
  }

  var normalized: [CGFloat] {
    components.map { $0 / 255.0 }
  }
}
