import SwiftUI

extension MarkdownStyle {
  public struct Color {
    var resolve: () -> PlatformColor?
  }
}

extension MarkdownStyle.Color {
  /// A context-dependent red color suitable for use in UI elements.
  public static let red = Self { .systemRed }

  /// A context-dependent orange color suitable for use in UI elements.
  public static let orange = Self { .systemOrange }

  /// A context-dependent yellow color suitable for use in UI elements.
  public static let yellow = Self { .systemYellow }

  /// A context-dependent green color suitable for use in UI elements.
  public static let green = Self { .systemGreen }

  /// A context-dependent teal color suitable for use in UI elements.
  public static let teal = Self { .systemTeal }

  /// A context-dependent blue color suitable for use in UI elements.
  public static let blue = Self { .systemBlue }

  /// A context-dependent indigo color suitable for use in UI elements.
  public static let indigo = Self { .systemIndigo }

  /// A context-dependent purple color suitable for use in UI elements.
  public static let purple = Self { .systemPurple }

  /// A context-dependent pink color suitable for use in UI elements.
  public static let pink = Self { .systemPink }

  /// A white color suitable for use in UI elements.
  public static let white = Self { .white }

  /// A context-dependent gray color suitable for use in UI elements.
  public static let gray = Self { .systemGray }

  /// A black color suitable for use in UI elements.
  public static let black = Self { .black }

  /// A clear color suitable for use in UI elements.
  public static let clear = Self { .clear }

  /// The color to use for primary content.
  public static let primary = Self {
    #if os(macOS)
      return .labelColor
    #elseif os(iOS) || os(tvOS)
      return .label
    #endif
  }

  /// The color to use for secondary content.
  public static let secondary = Self {
    #if os(macOS)
      return .secondaryLabelColor
    #elseif os(iOS) || os(tvOS)
      return .secondaryLabel
    #endif
  }

  /// The color to use for separators between different sections of content.
  public static let separator = Self {
    #if os(macOS)
      return .separatorColor
    #elseif os(iOS) || os(tvOS)
      return .separator
    #endif
  }

  /// Creates a color from a Core Graphics color.
  public init(cgColor: CGColor) {
    self.init {
      .init(cgColor: cgColor)
    }
  }

  /// Creates a constant color from red, green, and blue component values.
  public init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat = 1) {
    self.init {
      .init(red: red, green: green, blue: blue, alpha: opacity)
    }
  }

  /// Creates a constant grayscale color.
  public init(white: CGFloat, opacity: CGFloat = 1) {
    self.init {
      .init(white: white, alpha: opacity)
    }
  }

  /// Creates a constant color from hue, saturation, and brightness values.
  public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat = 1) {
    self.init {
      .init(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
    }
  }

  /// Creates a color from a color set that you indicate by name.
  public init(_ name: String, bundle: Bundle? = nil) {
    self.init {
      #if os(macOS)
        return .init(named: name, bundle: bundle)
      #elseif os(iOS) || os(tvOS)
        return .init(named: name, in: bundle, compatibleWith: nil)
      #endif
    }
  }

  public func opacity(_ opacity: CGFloat) -> MarkdownStyle.Color {
    modifier(.opacity(opacity))
  }
}

#if os(macOS)
  @available(macOS 11.0, *)
  @available(iOS, unavailable)
  @available(tvOS, unavailable)
  extension MarkdownStyle.Color {
    /// Creates a color from an AppKit color.
    public init(nsColor: NSColor) {
      self.init { nsColor }
    }
  }
#endif

#if os(iOS) || os(tvOS)
  @available(macOS, unavailable)
  @available(iOS 14.0, *)
  @available(tvOS 14.0, *)
  extension MarkdownStyle.Color {
    /// Creates a color from an UIKit color.
    public init(uiColor: UIColor) {
      self.init { uiColor }
    }
  }
#endif

extension MarkdownStyle.Color {
  fileprivate func modifier(_ modifier: MarkdownStyle.ColorModifier) -> MarkdownStyle.Color {
    MarkdownStyle.Color {
      guard var platformColor = self.resolve() else {
        return nil
      }
      modifier.modify(&platformColor)
      return platformColor
    }
  }
}

// MARK: - ColorModifier

extension MarkdownStyle {
  fileprivate struct ColorModifier {
    var modify: (inout PlatformColor) -> Void
  }
}

extension MarkdownStyle.ColorModifier {
  static func opacity(_ opacity: CGFloat) -> MarkdownStyle.ColorModifier {
    .init { platformColor in
      platformColor = platformColor.withAlphaComponent(opacity)
    }
  }
}

// MARK: - PlatformColor

extension MarkdownStyle {
  #if os(macOS)
    typealias PlatformColor = NSColor
  #elseif os(iOS) || os(tvOS)
    typealias PlatformColor = UIColor
  #endif
}
