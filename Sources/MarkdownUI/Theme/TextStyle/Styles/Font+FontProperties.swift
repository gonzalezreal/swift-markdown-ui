import SwiftUI

extension Font {
  static func withProperties(_ fontProperties: FontProperties) -> Font {
    var font: Font
    let size = round(fontProperties.size * fontProperties.scale)

    switch fontProperties.family {
    case .system(let design):
      font = .system(size: size, design: design)
    case .custom(let name):
      font = .custom(name, fixedSize: size)
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

    if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
      if fontProperties.width != .standard {
        font = font.width(fontProperties.width)
      }
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


import UIKit

extension UIFont {
    static func withProperties(_ fontProperties: FontProperties) -> UIFont {
        let size = round(fontProperties.size * fontProperties.scale)
        
        // 创建基础字体
        var descriptor: UIFontDescriptor
        switch fontProperties.family {
        case .system(let design):
            switch design {
            case .serif:
                descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
                    .withDesign(.serif) ?? UIFontDescriptor()
            case .rounded:
                descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
                    .withDesign(.rounded) ?? UIFontDescriptor()
            case .monospaced:
                descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
                    .withDesign(.monospaced) ?? UIFontDescriptor()
            default: // .default
                descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            }
        case .custom(let name):
            descriptor = UIFontDescriptor(name: name, size: size)
        }
        
        // 应用字重
        if fontProperties.weight != .regular {
            descriptor = descriptor.addingAttributes([
                .traits: [
                    UIFontDescriptor.TraitKey.weight: fontProperties.weight.uiFontWeight
                ]
            ])
        }
        
        // 应用斜体
        if fontProperties.style == .italic {
            var symbolicTraits = descriptor.symbolicTraits
            symbolicTraits.insert(.traitItalic)
            if let italicDescriptor = descriptor.withSymbolicTraits(symbolicTraits) {
                descriptor = italicDescriptor
            }
        }
        var font = UIFont(descriptor: descriptor, size: size)
        
        return font
    }
}

// 辅助扩展，将 Font.Weight 转换为 UIFont.Weight
private extension Font.Weight {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }
}
