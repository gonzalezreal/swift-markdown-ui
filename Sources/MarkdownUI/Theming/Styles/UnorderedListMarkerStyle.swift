import SwiftUI

public struct UnorderedListMarkerStyleConfiguration {
  public var listLevel: Int
}

public typealias UnorderedListMarkerStyle = ListMarkerStyle<UnorderedListMarkerStyleConfiguration>

extension UnorderedListMarkerStyle {
  public static var discCircleSquare: Self {
    .init { configuration in
      let markers = [
        Image(systemName: "circle.fill"),  // disc (a.k.a. bullet)
        Image(systemName: "circle"),  // circle (a.k.a. white bullet)
        Image(systemName: "square.fill"),  // square
      ]
      markers[min(configuration.listLevel, markers.count) - 1]
        .imageScale(.small)
        .scaleEffect(0.5)
    }
  }

  public static var dash: Self {
    .init { _ in
      Text("-")
    }
  }
}
