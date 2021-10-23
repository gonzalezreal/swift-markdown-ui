import SwiftUI

extension Markdown {
  public struct Font {
    var resolve: () -> PlatformFont
  }
}

extension Markdown.Font {
  /// A font with the large title text style.
  public static let largeTitle: Markdown.Font = .system(.largeTitle)

  /// A font with the title text style.
  public static let title: Markdown.Font = .system(.title)

  /// Create a font for second level hierarchical headings.
  public static let title2: Markdown.Font = .system(.title2)

  /// Create a font for third level hierarchical headings.
  public static let title3: Markdown.Font = .system(.title3)

  /// A font with the headline text style.
  public static let headline: Markdown.Font = .system(.headline)

  /// A font with the subheadline text style.
  public static let subheadline: Markdown.Font = .system(.subheadline)

  /// A font with the body text style.
  public static let body: Markdown.Font = .system(.body)

  /// A font with the callout text style.
  public static let callout: Markdown.Font = .system(.callout)

  /// A font with the footnote text style.
  public static let footnote: Markdown.Font = .system(.footnote)

  /// A font with the caption text style.
  public static let caption: Markdown.Font = .system(.caption)

  /// A font with the alternate caption text style.
  public static let caption2: Markdown.Font = .system(.caption2)

  /// Specifies a system font to use, along with the style, weight, and any design parameters you want applied to the text.
  public static func system(
    size: CGFloat,
    weight: SwiftUI.Font.Weight = .regular,
    design: SwiftUI.Font.Design = .default
  ) -> Markdown.Font {
    Markdown.Font {
      .systemFont(ofSize: size, weight: .init(weight))
    }
    .modifier(.design(design))
  }

  /// Gets a system font with the given style and design.
  public static func system(
    _ style: SwiftUI.Font.TextStyle,
    design: SwiftUI.Font.Design = .default
  ) -> Markdown.Font {
    Markdown.Font {
      .preferredFont(forTextStyle: .init(style))
    }
    .modifier(.design(design))
  }

  /// Create a custom font with the given `name` and `size` that scales with
  /// the body text style.
  public static func custom(_ name: String, size: CGFloat) -> Markdown.Font {
    Markdown.Font {
      let font: Markdown.PlatformFont =
        .init(name: name, size: size) ?? .systemFont(ofSize: size)
      #if os(macOS)
        return font
      #elseif os(iOS) || os(tvOS)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
      #endif
    }
  }

  /// Adds bold styling to the font.
  public func bold() -> Markdown.Font {
    #if os(macOS)
      modifier(.addingSymbolicTraits(.bold))
    #elseif os(iOS) || os(tvOS)
      modifier(.addingSymbolicTraits(.traitBold))
    #endif
  }

  /// Adds italics to the font.
  public func italic() -> Markdown.Font {
    #if os(macOS)
      modifier(.addingSymbolicTraits(.italic))
    #elseif os(iOS) || os(tvOS)
      modifier(.addingSymbolicTraits(.traitItalic))
    #endif
  }
}

extension Markdown.Font {
  func modifier(_ modifier: Markdown.FontModifier) -> Markdown.Font {
    Markdown.Font {
      var platformFont = self.resolve()
      modifier.modify(&platformFont)
      return platformFont
    }
  }
}

// MARK: - FontModifier

extension Markdown {
  struct FontModifier {
    var modify: (inout PlatformFont) -> Void
  }
}

extension Markdown.FontModifier {
  static func design(_ design: SwiftUI.Font.Design) -> Markdown.FontModifier {
    Markdown.FontModifier { platformFont in
      if let newDescriptor = platformFont.fontDescriptor.withDesign(.init(design)) {
        #if os(macOS)
          platformFont =
            .init(descriptor: newDescriptor, size: platformFont.pointSize) ?? platformFont
        #elseif os(iOS) || os(tvOS)
          platformFont = .init(descriptor: newDescriptor, size: platformFont.pointSize)
        #endif
      }
    }
  }

  static func addingSymbolicTraits(
    _ traits: Markdown.PlatformFontDescriptor.SymbolicTraits
  ) -> Markdown.FontModifier {
    Markdown.FontModifier { platformFont in
      #if os(macOS)
        let newTraits = platformFont.fontDescriptor.symbolicTraits.union(traits)
        platformFont =
          .init(
            descriptor: platformFont.fontDescriptor.withSymbolicTraits(newTraits),
            size: platformFont.pointSize
          ) ?? platformFont
      #elseif os(iOS) || os(tvOS)
        let newTraits = platformFont.fontDescriptor.symbolicTraits.union(traits)
        if let newDescriptor = platformFont.fontDescriptor.withSymbolicTraits(newTraits) {
          platformFont = .init(descriptor: newDescriptor, size: platformFont.pointSize)
        }
      #endif
    }
  }
}

// MARK: - PlatformFont

extension Markdown {
  #if os(macOS)
    typealias PlatformFont = NSFont
    typealias PlatformFontDescriptor = NSFontDescriptor
  #elseif os(iOS) || os(tvOS)
    typealias PlatformFont = UIFont
    typealias PlatformFontDescriptor = UIFontDescriptor
  #endif
}

extension Markdown.PlatformFont.Weight {
  init(_ weight: SwiftUI.Font.Weight) {
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

extension Markdown.PlatformFont.TextStyle {
  init(_ textStyle: SwiftUI.Font.TextStyle) {
    switch textStyle {
    case .largeTitle:
      self = .largeTitle
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

extension Markdown.PlatformFontDescriptor.SystemDesign {
  init(_ design: SwiftUI.Font.Design) {
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
