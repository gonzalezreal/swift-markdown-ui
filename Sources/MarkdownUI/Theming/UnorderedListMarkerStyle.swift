import SwiftUI

extension Markdown {
  public struct UnorderedListMarkerStyle {
    public struct Configuration {
      public var listLevel: Int
    }

    var makeBody: (Configuration) -> AnyView

    public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
      self.makeBody = { configuration in
        AnyView(makeBody(configuration))
      }
    }
  }
}

extension Markdown.UnorderedListMarkerStyle {
  public static var discCircleSquare: Self {
    .init { configuration in
      let markers = [
        SwiftUI.Image(systemName: "circle.fill"), // disc (a.k.a. bullet)
        SwiftUI.Image(systemName: "circle"),      // circle (a.k.a. white bullet)
        SwiftUI.Image(systemName: "square.fill")  // square
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
