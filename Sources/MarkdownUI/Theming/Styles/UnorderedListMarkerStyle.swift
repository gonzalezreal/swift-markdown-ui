import SwiftUI

public struct UnorderedListMarkerStyleConfiguration {
  public var listLevel: Int
}

public typealias UnorderedListMarkerStyle = ListMarkerStyle<UnorderedListMarkerStyleConfiguration>

extension UnorderedListMarkerStyle {
  private enum Constants {
    static let bulletFontSize = Font.TextStyle.body.pointSize / 3
  }

  public static var disc: Self {
    .init { configuration in
      Image(systemName: "circle.fill")
        .font(.system(size: Constants.bulletFontSize))
    }
  }

  public static var circle: Self {
    .init { configuration in
      Image(systemName: "circle")
        .font(.system(size: Constants.bulletFontSize))
    }
  }

  public static var square: Self {
    .init { configuration in
      Image(systemName: "square.fill")
        .font(.system(size: Constants.bulletFontSize))
    }
  }

  public static var discCircleSquare: Self {
    .init { configuration in
      let styles: [UnorderedListMarkerStyle] = [.disc, .circle, .square]
      styles[min(configuration.listLevel, styles.count) - 1]
        .makeBody(configuration)
    }
  }

  public static var dash: Self {
    .init { _ in
      Text("-")
    }
  }
}
