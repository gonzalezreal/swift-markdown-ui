import SwiftUI

extension MarkdownStyle {
  public struct Font {
    var resolve: () -> PlatformFont
  }
}

extension MarkdownStyle.Font {
  /// A font with the large title text style.
  public static let largeTitle: MarkdownStyle.Font = .system(.largeTitle)

  /// A font with the title text style.
  public static let title: MarkdownStyle.Font = .system(.title)

  /// Create a font for second level hierarchical headings.
  public static let title2: MarkdownStyle.Font = .system(.title2)

  /// Create a font for third level hierarchical headings.
  public static let title3: MarkdownStyle.Font = .system(.title3)

  /// A font with the headline text style.
  public static let headline: MarkdownStyle.Font = .system(.headline)

  /// A font with the subheadline text style.
  public static let subheadline: MarkdownStyle.Font = .system(.subheadline)

  /// A font with the body text style.
  public static let body: MarkdownStyle.Font = .system(.body)

  /// A font with the callout text style.
  public static let callout: MarkdownStyle.Font = .system(.callout)

  /// A font with the footnote text style.
  public static let footnote: MarkdownStyle.Font = .system(.footnote)

  /// A font with the caption text style.
  public static let caption: MarkdownStyle.Font = .system(.caption)

  /// A font with the alternate caption text style.
  public static let caption2: MarkdownStyle.Font = .system(.caption2)

  /// Specifies a system font to use, along with the style, weight, and any design parameters you want applied to the text.
  public static func system(
    size: CGFloat,
    weight: SwiftUI.Font.Weight = .regular,
    design: SwiftUI.Font.Design = .default
  ) -> MarkdownStyle.Font {
    MarkdownStyle.Font {
      .systemFont(ofSize: size, weight: .init(weight))
    }
    .modifier(.design(design))
  }

  /// Gets a system font with the given style and design.
  public static func system(
    _ style: SwiftUI.Font.TextStyle,
    design: SwiftUI.Font.Design = .default
  ) -> MarkdownStyle.Font {
    MarkdownStyle.Font {
      .preferredFont(forTextStyle: .init(style))
    }
    .modifier(.design(design))
  }

  /// Create a custom font with the given `name` and `size` that scales with
  /// the body text style.
  public static func custom(_ name: String, size: CGFloat) -> MarkdownStyle.Font {
    MarkdownStyle.Font {
      let font: MarkdownStyle.PlatformFont =
        .init(name: name, size: size) ?? .systemFont(ofSize: size)
      #if os(macOS)
        return font
      #elseif os(iOS) || os(tvOS)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
      #endif
    }
  }

  /// Adds bold styling to the font.
  public func bold() -> MarkdownStyle.Font {
    #if os(macOS)
      modifier(.addingSymbolicTraits(.bold))
    #elseif os(iOS) || os(tvOS)
      modifier(.addingSymbolicTraits(.traitBold))
    #endif
  }

  /// Adds italics to the font.
  public func italic() -> MarkdownStyle.Font {
    #if os(macOS)
      modifier(.addingSymbolicTraits(.italic))
    #elseif os(iOS) || os(tvOS)
      modifier(.addingSymbolicTraits(.traitItalic))
    #endif
  }

  /// Adjusts the font to use monospace digits.
  public func monospacedDigit() -> MarkdownStyle.Font {
    let attributes: [MarkdownStyle.PlatformFontDescriptor.AttributeName: Any]
    #if os(macOS)
      attributes = [
        .featureSettings: [
          [
            MarkdownStyle.PlatformFontDescriptor.FeatureKey.typeIdentifier: kNumberSpacingType,
            MarkdownStyle.PlatformFontDescriptor.FeatureKey.selectorIdentifier:
              kMonospacedNumbersSelector,
          ]
        ]
      ]
    #elseif os(iOS) || os(tvOS)
      attributes = [
        .featureSettings: [
          [
            MarkdownStyle.PlatformFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            MarkdownStyle.PlatformFontDescriptor.FeatureKey.typeIdentifier:
              kMonospacedNumbersSelector,
          ]
        ]
      ]
    #endif
    return modifier(.addingAttributes(attributes))
  }

  public func scale(_ scale: CGFloat) -> MarkdownStyle.Font {
    modifier(.scale(scale))
  }

  public func monospaced() -> MarkdownStyle.Font {
    modifier(.monospaced())
  }
}

extension MarkdownStyle.Font {
  fileprivate func modifier(_ modifier: MarkdownStyle.FontModifier) -> MarkdownStyle.Font {
    MarkdownStyle.Font {
      var platformFont = self.resolve()
      modifier.modify(&platformFont)
      return platformFont
    }
  }
}

// MARK: - FontModifier

extension MarkdownStyle {
  fileprivate struct FontModifier {
    var modify: (inout PlatformFont) -> Void
  }
}

extension MarkdownStyle.FontModifier {
  fileprivate static func design(_ design: SwiftUI.Font.Design) -> MarkdownStyle.FontModifier {
    MarkdownStyle.FontModifier { platformFont in
      if let newDescriptor = platformFont.fontDescriptor.withDesign(.init(design)) {
        #if os(macOS)
          platformFont =
            .init(descriptor: newDescriptor, size: 0) ?? platformFont
        #elseif os(iOS) || os(tvOS)
          platformFont = .init(descriptor: newDescriptor, size: 0)
        #endif
      }
    }
  }

  fileprivate static func scale(_ scale: CGFloat) -> MarkdownStyle.FontModifier {
    MarkdownStyle.FontModifier { platformFont in
      platformFont = platformFont.withSize(round(platformFont.pointSize * scale))
    }
  }

  fileprivate static func monospaced() -> MarkdownStyle.FontModifier {
    MarkdownStyle.FontModifier { platformFont in
      var monospacedPlatformFont = platformFont
      MarkdownStyle.FontModifier.design(.monospaced).modify(&monospacedPlatformFont)

      if platformFont == monospacedPlatformFont {
        let traits = platformFont.fontDescriptor.symbolicTraits
        platformFont = .monospacedSystemFont(ofSize: platformFont.pointSize, weight: .regular)
        MarkdownStyle.FontModifier.addingSymbolicTraits(traits).modify(&platformFont)
      } else {
        platformFont = monospacedPlatformFont
      }
    }
  }

  fileprivate static func addingSymbolicTraits(
    _ symbolicTraits: MarkdownStyle.PlatformFontDescriptor.SymbolicTraits
  ) -> MarkdownStyle.FontModifier {
    MarkdownStyle.FontModifier { platformFont in
      #if os(macOS)
        platformFont =
          .init(
            descriptor: platformFont.fontDescriptor.withSymbolicTraits(symbolicTraits),
            size: 0
          ) ?? platformFont
      #elseif os(iOS) || os(tvOS)
        if let newDescriptor = platformFont.fontDescriptor.withSymbolicTraits(symbolicTraits) {
          platformFont = .init(descriptor: newDescriptor, size: 0)
        }
      #endif
    }
  }

  fileprivate static func addingAttributes(
    _ attributes: [MarkdownStyle.PlatformFontDescriptor.AttributeName: Any]
  ) -> MarkdownStyle.FontModifier {
    MarkdownStyle.FontModifier { platformFont in
      let newDescriptor = platformFont.fontDescriptor.addingAttributes(attributes)
      #if os(macOS)
        platformFont = .init(descriptor: newDescriptor, size: 0) ?? platformFont
      #elseif os(iOS) || os(tvOS)
        platformFont = .init(descriptor: newDescriptor, size: 0)
      #endif
    }
  }
}

// MARK: - PlatformFont

extension MarkdownStyle {
  #if os(macOS)
    typealias PlatformFont = NSFont
    fileprivate typealias PlatformFontDescriptor = NSFontDescriptor
  #elseif os(iOS) || os(tvOS)
    typealias PlatformFont = UIFont
    fileprivate typealias PlatformFontDescriptor = UIFontDescriptor
  #endif
}

extension MarkdownStyle.PlatformFont.Weight {
  fileprivate init(_ weight: SwiftUI.Font.Weight) {
    switch weight {
    case .ultraLight:
      self = .ultraLight
    case .thin:
      self = .thin
    case .light:
      self = .light
    case .regular:
      self = .regular
    case .medium:
      self = .medium
    case .semibold:
      self = .semibold
    case .bold:
      self = .bold
    case .heavy:
      self = .heavy
    case .black:
      self = .black
    default:
      self = .regular
    }
  }
}

extension MarkdownStyle.PlatformFont.TextStyle {
  fileprivate init(_ textStyle: SwiftUI.Font.TextStyle) {
    switch textStyle {
    case .largeTitle:
      #if os(tvOS)
        self = .title1
      #else
        self = .largeTitle
      #endif
    case .title:
      self = .title1
    case .title2:
      self = .title2
    case .title3:
      self = .title3
    case .headline:
      self = .headline
    case .subheadline:
      self = .subheadline
    case .body:
      self = .body
    case .callout:
      self = .callout
    case .footnote:
      self = .footnote
    case .caption:
      self = .caption1
    case .caption2:
      self = .caption2
    @unknown default:
      self = .body
    }
  }
}

extension MarkdownStyle.PlatformFontDescriptor.SystemDesign {
  fileprivate init(_ design: SwiftUI.Font.Design) {
    switch design {
    case .`default`:
      self = .`default`
    case .serif:
      self = .serif
    case .rounded:
      self = .rounded
    case .monospaced:
      self = .monospaced
    @unknown default:
      self = .`default`
    }
  }
}
