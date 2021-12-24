import SwiftUI

extension MarkdownStyle {
  public struct Color: Hashable {
    var platformColor: PlatformColor?
  }
}

extension MarkdownStyle.Color {
  /// A context-dependent red color suitable for use in UI elements.
  public static let red = Self(platformColor: .systemRed)

  /// A context-dependent orange color suitable for use in UI elements.
  public static let orange = Self(platformColor: .systemOrange)

  /// A context-dependent yellow color suitable for use in UI elements.
  public static let yellow = Self(platformColor: .systemYellow)

  /// A context-dependent green color suitable for use in UI elements.
  public static let green = Self(platformColor: .systemGreen)

  /// A context-dependent teal color suitable for use in UI elements.
  public static let teal = Self(platformColor: .systemTeal)

  /// A context-dependent blue color suitable for use in UI elements.
  public static let blue = Self(platformColor: .systemBlue)

  /// A context-dependent indigo color suitable for use in UI elements.
  public static let indigo = Self(platformColor: .systemIndigo)

  /// A context-dependent purple color suitable for use in UI elements.
  public static let purple = Self(platformColor: .systemPurple)

  /// A context-dependent pink color suitable for use in UI elements.
  public static let pink = Self(platformColor: .systemPink)

  /// A white color suitable for use in UI elements.
  public static let white = Self(platformColor: .white)

  /// A context-dependent gray color suitable for use in UI elements.
  public static let gray = Self(platformColor: .systemGray)

  /// A black color suitable for use in UI elements.
  public static let black = Self(platformColor: .black)

  /// A clear color suitable for use in UI elements.
  public static let clear = Self(platformColor: .clear)

  #if os(macOS)
    /// The color to use for primary content.
    public static let primary = Self(platformColor: .labelColor)
  #elseif os(iOS) || os(tvOS)
    /// The color to use for primary content.
    public static let primary = Self(platformColor: .label)
  #endif

  #if os(macOS)
    /// The color to use for secondary content.
    public static let secondary = Self(platformColor: .secondaryLabelColor)
  #elseif os(iOS) || os(tvOS)
    /// The color to use for secondary content.
    public static let secondary = Self(platformColor: .secondaryLabel)
  #endif

  #if os(macOS)
    /// The color to use for separators between different sections of content.
    public static let separator = Self(platformColor: .separatorColor)
  #elseif os(iOS) || os(tvOS)
    /// The color to use for separators between different sections of content.
    public static let separator = Self(platformColor: .separator)
  #endif

  /// Creates a color from a Core Graphics color.
  public init(cgColor: CGColor) {
    self.init(platformColor: .init(cgColor: cgColor))
  }

  /// Creates a constant color from red, green, and blue component values.
  public init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat = 1) {
    self.init(platformColor: .init(red: red, green: green, blue: blue, alpha: opacity))
  }

  /// Creates a constant grayscale color.
  public init(white: CGFloat, opacity: CGFloat = 1) {
    self.init(platformColor: .init(white: white, alpha: opacity))
  }

  /// Creates a constant color from hue, saturation, and brightness values.
  public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat = 1) {
    self.init(
      platformColor: .init(
        hue: hue, saturation: saturation, brightness: brightness, alpha: opacity
      )
    )
  }

  /// Creates a color from a color set that you indicate by name.
  public init(_ name: String, bundle: Bundle? = nil) {
    #if os(macOS)
      self.init(platformColor: .init(named: name, bundle: bundle))
    #elseif os(iOS) || os(tvOS)
      self.init(platformColor: .init(named: name, in: bundle, compatibleWith: nil))
    #endif
  }

  public func opacity(_ opacity: CGFloat) -> MarkdownStyle.Color {
    .init(platformColor: self.platformColor?.withAlphaComponent(opacity))
  }
}

#if os(macOS)
  @available(macOS 11.0, *)
  @available(iOS, unavailable)
  @available(tvOS, unavailable)
  extension MarkdownStyle.Color {
    /// Creates a color from an AppKit color.
    public init(nsColor: NSColor) {
      self.init(platformColor: nsColor)
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
      self.init(platformColor: uiColor)
    }
  }
#endif

// MARK: - PlatformColor

extension MarkdownStyle {
  #if os(macOS)
    typealias PlatformColor = NSColor
  #elseif os(iOS) || os(tvOS)
    typealias PlatformColor = UIColor
  #endif
}
