import SwiftUI

/// The properties of a list marker in a markdown list.
///
/// The theme ``Theme/bulletedListMarker`` and ``Theme/numberedListMarker``
/// block styles receive a `ListMarkerConfiguration` input in their `body` closure.
public struct ListMarkerConfiguration {
  /// The list level (one-based) of the item to which the marker applies.
  public let listLevel: Int

  /// The position (one-based) of the item to which the marker applies.
  public let itemNumber: Int
}

extension BlockStyle where Configuration == ListMarkerConfiguration {
  /// A list marker style that uses decimal numbers beginning with 1.
  public static var decimal: Self {
    decimal(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that uses uppercase roman numerals beginning with `I`.
  public static var upperRoman: Self {
    upperRoman(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that uses lowercase roman numerals beginning with `i`.
  public static var lowerRoman: Self {
    lowerRoman(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that uses a dash.
  public static var dash: Self {
    dash(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that uses a filled circle.
  public static var disc: Self {
    disc(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that uses a hollow circle.
  public static var circle: Self {
    circle(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that uses a filled square.
  public static var square: Self {
    square(minWidth: .em(1.5), alignment: .trailing)
  }

  /// A list marker style that alternates between disc, circle, and square, depending on the list level.
  public static var discCircleSquare: Self {
    BlockStyle { configuration in
      let styles: [Self] = [.disc, .circle, .square]
      styles[min(configuration.listLevel, styles.count) - 1]
        .makeBody(configuration: configuration)
    }
  }
}

// MARK: Dynamic

extension BlockStyle where Configuration == ListMarkerConfiguration {
  /// A list marker style that uses decimal numbers beginning with 1.
  public static func decimal(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { configuration in
      Text("\(configuration.itemNumber).")
        .monospacedDigit()
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }

  /// A list marker style that uses uppercase roman numerals beginning with `I`.
  public static func upperRoman(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { configuration in
      Text(configuration.itemNumber.roman + ".")
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }

  /// A list marker style that uses lowercase roman numerals beginning with `i`.
  public static func lowerRoman(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { configuration in
      Text(configuration.itemNumber.roman.lowercased() + ".")
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }

  /// A list marker style that uses a dash.
  public static func dash(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { _ in
      Text("-")
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }

  /// A list marker style that uses a filled circle.
  public static func disc(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { _ in
      ListBullet.disc
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }

  /// A list marker style that uses a hollow circle.
  public static func circle(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { _ in
      ListBullet.circle
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }

  /// A list marker style that uses a filled square.
  public static func square(minWidth: RelativeSize, alignment: Alignment = .center) -> Self {
    BlockStyle { _ in
      ListBullet.square
        .relativeFrame(minWidth: minWidth, alignment: alignment)
    }
  }
}
