import SwiftUI

/// Represents a size or a length, such as width, margin, padding, or font size.
///
/// `Size` values are used in some text styles like ``FontSize`` or view modifiers like
/// `markdownBlockMargins(top:bottom:)` to express either a fixed value or a value
/// relative to the font size.
///
/// You can use the ``points(_:)`` method to create an absolute size value measured in points.
///
/// ```swift
/// label
///   .markdownBlockMargins(top: .points(24), bottom: .points(16))
/// ```
///
/// Use the ``em(_:)`` and the ``rem(_:)`` methods to create values relative to the current and
/// root font sizes, respectively. For example, in the following snippet, with a root font size of 17 points,
/// the line spacing will be resolved to 4.25 points (`17 * 2 * 0.125`) and the padding to 8.5 points
/// (`17 * 0.5`).
///
/// ```swift
/// label
///   .lineSpacing(.em(0.125))
///   .padding(.rem(0.5))
///   .markdownTextStyle {
///     FontWeight(.semibold)
///     FontSize(.em(2))
///   }
/// ```
public struct Size: Hashable {
  enum Unit: Hashable {
    case points
    case em
    case rem
  }

  var value: CGFloat
  var unit: Unit
}

extension Size {
  /// A size with a value of zero.
  public static let zero = Size(value: 0, unit: .points)

  /// Creates an absolute size value measured in points.
  public static func points(_ value: CGFloat) -> Size {
    .init(value: value, unit: .points)
  }

  /// Creates a size value relative to the current font size.
  public static func em(_ value: CGFloat) -> Size {
    .init(value: value, unit: .em)
  }

  /// Creates a size value relative to the root font size.
  public static func rem(_ value: CGFloat) -> Size {
    .init(value: value, unit: .rem)
  }

  func points(relativeTo fontProperties: FontProperties? = nil) -> CGFloat {
    let fontProperties = fontProperties ?? .init()

    switch self.unit {
    case .points:
      return value
    case .em:
      return round(value * fontProperties.scaledSize)
    case .rem:
      return round(value * fontProperties.size)
    }
  }
}

extension View {
  /// Positions this view within an invisible frame with the specified size.
  ///
  /// This method behaves like the one in SwiftUI but takes `Size` values instead of `CGFloat` for the width and height.
  public func frame(
    width: Size? = nil,
    height: Size? = nil,
    alignment: Alignment = .center
  ) -> some View {
    TextStyleAttributesReader { attributes in
      self.frame(
        width: width?.points(relativeTo: attributes.fontProperties),
        height: height?.points(relativeTo: attributes.fontProperties),
        alignment: alignment
      )
    }
  }

  /// Positions this view within an invisible frame having the specified size constraints.
  ///
  /// This method behaves like the one in SwiftUI but takes `Size` values instead of `CGFloat` for the width and height.
  public func frame(minWidth: Size, alignment: Alignment = .center) -> some View {
    TextStyleAttributesReader { attributes in
      self.frame(
        minWidth: minWidth.points(relativeTo: attributes.fontProperties),
        alignment: alignment
      )
    }
  }

  /// Adds an equal padding amount to specific edges of this view.
  ///
  /// This method behaves like the one in SwiftUI except that it takes a `Size` value instead of a `CGFloat` for the padding amount.
  public func padding(_ edges: Edge.Set = .all, _ length: Size) -> some View {
    TextStyleAttributesReader { attributes in
      self.padding(edges, length.points(relativeTo: attributes.fontProperties))
    }
  }

  /// Sets the amount of space between lines of text in this view.
  ///
  /// This method behaves like the one in SwiftUI except that it takes a `Size` value instead of a `CGFloat` for the spacing amount.
  public func lineSpacing(_ lineSpacing: Size) -> some View {
    TextStyleAttributesReader { attributes in
      self.lineSpacing(lineSpacing.points(relativeTo: attributes.fontProperties))
    }
  }
}
