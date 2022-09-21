import SwiftUI

public struct ListMarkerStyle {
  public struct Configuration {
    public var listLevel: Int
    public var number: Int
    public var checkbox: Checkbox?
  }

  var makeBody: (Configuration) -> AnyView

  public init<Body>(
    @ViewBuilder makeBody: @escaping (_ configuration: Configuration) -> Body
  ) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

extension ListMarkerStyle {
  public static var empty: Self {
    .init { _ in
      EmptyView()
    }
  }
}

// MARK: - Numbered

extension ListMarkerStyle {
  public static var decimal: Self {
    .init { configuration in
      Text("\(configuration.number).")
        .monospacedDigit()
    }
  }

  public static var upperRoman: Self {
    .init { configuration in
      Text(configuration.number.roman + ".")
    }
  }

  public static var lowerRoman: Self {
    .init { configuration in
      Text(configuration.number.roman.lowercased() + ".")
    }
  }
}

// MARK: - Bullets

extension ListMarkerStyle {
  private enum Constants {
    static let bulletFontSize = Font.TextStyle.body.pointSize / 3
  }

  public static var disc: Self {
    .init { _ in
      Image(systemName: "circle.fill")
        .font(.system(size: Constants.bulletFontSize))
    }
  }

  public static var circle: Self {
    .init { _ in
      Image(systemName: "circle")
        .font(.system(size: Constants.bulletFontSize))
    }
  }

  public static var square: Self {
    .init { _ in
      Image(systemName: "square.fill")
        .font(.system(size: Constants.bulletFontSize))
    }
  }

  public static var discCircleSquare: Self {
    .init { configuration in
      let styles: [ListMarkerStyle] = [.disc, .circle, .square]
      styles[min(configuration.listLevel, styles.count) - 1]
        .makeBody(configuration)
    }
  }

  public static var dash: Self {
    .init { _ in Text("-") }
  }
}

// MARK: - Tasks

extension ListMarkerStyle {
  public static var checkmarkSquareFill: Self {
    .init { configuration in
      Image(checkbox: configuration.checkbox, checked: "checkmark.square.fill", unchecked: "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
    }
  }
}
