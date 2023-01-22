import SwiftUI

extension Font {
  static func withProperties(_ fontProperties: FontProperties) -> Font {
    var font: Font
    let size = round(fontProperties.size * fontProperties.scale)

    switch fontProperties.family {
    case .system(let design):
      font = .system(size: size, design: design)
    case .custom(let name):
      font = .custom(name, size: size)
    }

    switch fontProperties.familyVariant {
    case .normal:
      break  // do nothing
    case .monospaced:
      font = font.monospaced()
    }

    switch fontProperties.capsVariant {
    case .normal:
      break  // do nothing
    case .smallCaps:
      font = font.smallCaps()
    case .lowercaseSmallCaps:
      font = font.lowercaseSmallCaps()
    case .uppercaseSmallCaps:
      font = font.uppercaseSmallCaps()
    }

    switch fontProperties.digitVariant {
    case .normal:
      break  // do nothing
    case .monospaced:
      font = font.monospacedDigit()
    }

    if fontProperties.weight != .regular {
      font = font.weight(fontProperties.weight)
    }

    switch fontProperties.style {
    case .normal:
      break  // do nothing
    case .italic:
      font = font.italic()
    }

    return font
  }
}
