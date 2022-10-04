import SwiftUI

extension MarkdownStyle {
  /// An environment-dependent font that you can use to style a ``Markdown`` view.
  ///
  /// This type mimics the `SwiftUI.Font` API and provides the `Markdown` view implementation
  /// access to the underlying platform font.
  public struct Font: Hashable {
    private var provider: AnyHashable

    func resolve(sizeCategory: ContentSizeCategory = .large) -> PlatformFont {
      guard let fontProvider = self.provider.base as? FontProvider else {
        fatalError("provider should conform to FontProvider")
      }
      #if os(macOS)
        return .init(descriptor: fontProvider.fontDescriptor(compatibleWith: sizeCategory), size: 0)
          ?? .preferredFont(forTextStyle: .body)
      #elseif os(iOS) || os(tvOS)
        return .init(descriptor: fontProvider.fontDescriptor(compatibleWith: sizeCategory), size: 0)
      #endif
    }
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
    .init(
      provider: SystemFontProvider(
        size: size,
        weight: weight,
        design: design
      )
    )
  }

  /// Gets a system font with the given style and design.
  public static func system(
    _ style: SwiftUI.Font.TextStyle,
    design: SwiftUI.Font.Design = .default
  ) -> MarkdownStyle.Font {
    .init(
      provider: TextStyleFontProvider(
        style: style,
        design: design
      )
    )
  }

  /// Create a custom font with the given `name` and `size` that scales with
  /// the body text style.
  public static func custom(_ name: String, size: CGFloat) -> MarkdownStyle.Font {
    .init(
      provider: CustomFontProvider(
        name: name,
        size: size,
        textStyle: .body
      )
    )
  }

  /// Adds bold styling to the font.
  public func bold() -> MarkdownStyle.Font {
    .init(
      provider: FontModifierProvider(
        base: provider,
        modifier: BoldFontModifier()
      )
    )
  }

  /// Adds italics to the font.
  public func italic() -> MarkdownStyle.Font {
    .init(
      provider: FontModifierProvider(
        base: provider,
        modifier: ItalicFontModifier()
      )
    )
  }

  /// Adjusts the font to use monospace digits.
  public func monospacedDigit() -> MarkdownStyle.Font {
    .init(
      provider: FontModifierProvider(
        base: provider,
        modifier: MonospacedDigitFontModifier()
      )
    )
  }

  /// Switches the font to a monospaced version of the same family as the base
  /// font or a default monospaced font if no suitable font face in the same family is found.
  public func monospaced() -> MarkdownStyle.Font {
    .init(
      provider: FontModifierProvider(
        base: provider,
        modifier: MonospacedFontModifier()
      )
    )
  }

  public func scale(_ scale: CGFloat) -> MarkdownStyle.Font {
    .init(
      provider: FontModifierProvider(
        base: provider,
        modifier: ScaleFontModifier(scale: scale)
      )
    )
  }
}

// MARK: - FontProvider

private protocol FontProvider {
  func fontDescriptor(compatibleWith sizeCategory: ContentSizeCategory) -> PlatformFontDescriptor
}

private struct TextStyleFontProvider: Hashable, FontProvider {
  var style: SwiftUI.Font.TextStyle
  var design: SwiftUI.Font.Design

  func fontDescriptor(compatibleWith sizeCategory: ContentSizeCategory) -> PlatformFontDescriptor {
    #if os(macOS)
      let fontDescriptor = PlatformFontDescriptor.preferredFontDescriptor(
        forTextStyle: .init(style)
      )
    #elseif os(iOS) || os(tvOS)
      let fontDescriptor = PlatformFontDescriptor.preferredFontDescriptor(
        withTextStyle: .init(style),
        compatibleWith: .init(preferredContentSizeCategory: .init(sizeCategory))
      )
    #endif

    return fontDescriptor.withDesign(.init(design)) ?? fontDescriptor
  }
}

private struct SystemFontProvider: Hashable, FontProvider {
  var size: CGFloat
  var weight: SwiftUI.Font.Weight
  var design: SwiftUI.Font.Design

  func fontDescriptor(compatibleWith _: ContentSizeCategory) -> PlatformFontDescriptor {
    let fontDescriptor = PlatformFont.systemFont(ofSize: size, weight: .init(weight))
      .fontDescriptor
    return fontDescriptor.withDesign(.init(design)) ?? fontDescriptor
  }
}

private struct CustomFontProvider: Hashable, FontProvider {
  var name: String
  var size: CGFloat
  var textStyle: SwiftUI.Font.TextStyle?

  func fontDescriptor(compatibleWith sizeCategory: ContentSizeCategory) -> PlatformFontDescriptor {
    var size = self.size

    #if os(iOS) || os(tvOS)
      if let textStyle = self.textStyle {
        size = UIFontMetrics(forTextStyle: .init(textStyle))
          .scaledValue(
            for: size,
            compatibleWith: .init(preferredContentSizeCategory: .init(sizeCategory))
          )
      }
    #endif

    return .init(name: name, size: size)
  }
}

private struct FontModifierProvider<M>: Hashable, FontProvider where M: Hashable, M: FontModifier {
  var base: AnyHashable
  var modifier: M

  func fontDescriptor(compatibleWith sizeCategory: ContentSizeCategory) -> PlatformFontDescriptor {
    guard let fontProvider = self.base.base as? FontProvider else {
      fatalError("base should conform to FontProvider")
    }
    var fontDescriptor = fontProvider.fontDescriptor(compatibleWith: sizeCategory)
    modifier.modify(&fontDescriptor)
    return fontDescriptor
  }
}

// MARK: - FontModifier

private protocol FontModifier {
  func modify(_ fontDescriptor: inout PlatformFontDescriptor)
}

private struct BoldFontModifier: Hashable, FontModifier {
  func modify(_ fontDescriptor: inout PlatformFontDescriptor) {
    #if os(macOS)
      fontDescriptor = fontDescriptor.withSymbolicTraits(
        fontDescriptor.symbolicTraits.union(.bold)
      )
    #elseif os(iOS) || os(tvOS)
      fontDescriptor =
        fontDescriptor.withSymbolicTraits(
          fontDescriptor.symbolicTraits.union(.traitBold)
        ) ?? fontDescriptor
    #endif
  }
}

private struct ItalicFontModifier: Hashable, FontModifier {
  func modify(_ fontDescriptor: inout PlatformFontDescriptor) {
    #if os(macOS)
      fontDescriptor = fontDescriptor.withSymbolicTraits(
        fontDescriptor.symbolicTraits.union(.italic)
      )
    #elseif os(iOS) || os(tvOS)
      fontDescriptor =
        fontDescriptor.withSymbolicTraits(
          fontDescriptor.symbolicTraits.union(.traitItalic)
        ) ?? fontDescriptor
    #endif
  }
}

private struct MonospacedDigitFontModifier: Hashable, FontModifier {
  func modify(_ fontDescriptor: inout PlatformFontDescriptor) {
    #if os(macOS)
      fontDescriptor = fontDescriptor.addingAttributes(
        [
          .featureSettings: [
            [
              PlatformFontDescriptor.FeatureKey.typeIdentifier: kNumberSpacingType,
              PlatformFontDescriptor.FeatureKey.selectorIdentifier:
                kMonospacedNumbersSelector,
            ]
          ]
        ]
      )
    #elseif os(iOS) || os(tvOS)
      fontDescriptor = fontDescriptor.addingAttributes(
        [
          .featureSettings: [
            [
              PlatformFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
              PlatformFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector,
            ]
          ]
        ]
      )
    #endif
  }
}

private struct MonospacedFontModifier: Hashable, FontModifier {
  func modify(_ fontDescriptor: inout PlatformFontDescriptor) {
    let newFontDescriptor =
      fontDescriptor.withDesign(.monospaced)
      ?? PlatformFont.monospacedSystemFont(
        ofSize: fontDescriptor.pointSize,
        weight: .regular
      ).fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits)

    #if os(macOS)
      fontDescriptor = newFontDescriptor
    #elseif os(iOS) || os(tvOS)
      fontDescriptor = newFontDescriptor ?? fontDescriptor
    #endif
  }
}

private struct ScaleFontModifier: Hashable, FontModifier {
  var scale: CGFloat

  func modify(_ fontDescriptor: inout PlatformFontDescriptor) {
    fontDescriptor = fontDescriptor.withSize(round(fontDescriptor.pointSize * scale))
  }
}

// MARK: - PlatformFont

#if os(macOS)
  typealias PlatformFont = NSFont
  private typealias PlatformFontDescriptor = NSFontDescriptor
#elseif os(iOS) || os(tvOS)
  typealias PlatformFont = UIFont
  private typealias PlatformFontDescriptor = UIFontDescriptor
#endif

extension PlatformFont.Weight {
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

extension PlatformFont.TextStyle {
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

extension PlatformFontDescriptor.SystemDesign {
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

#if os(iOS) || os(tvOS)
  extension UIContentSizeCategory {
    fileprivate init(_ contentSizeCategory: ContentSizeCategory) {
      switch contentSizeCategory {
      case .extraSmall:
        self = .extraSmall
      case .small:
        self = .small
      case .medium:
        self = .medium
      case .large:
        self = .large
      case .extraLarge:
        self = .extraLarge
      case .extraExtraLarge:
        self = .extraExtraLarge
      case .extraExtraExtraLarge:
        self = .extraExtraExtraLarge
      case .accessibilityMedium:
        self = .accessibilityMedium
      case .accessibilityLarge:
        self = .accessibilityLarge
      case .accessibilityExtraLarge:
        self = .accessibilityExtraLarge
      case .accessibilityExtraExtraLarge:
        self = .accessibilityExtraExtraLarge
      case .accessibilityExtraExtraExtraLarge:
        self = .accessibilityExtraExtraExtraLarge
      @unknown default:
        self = .large
      }
    }
  }
#endif
