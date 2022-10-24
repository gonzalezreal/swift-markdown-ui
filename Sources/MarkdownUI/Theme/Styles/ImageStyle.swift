import SwiftUI

public struct ImageStyle {
  public struct Configuration {
    public struct Content: View {
      init<C: View>(_ content: C) {
        self.body = AnyView(content)
      }

      public let body: AnyView
    }

    public let content: Content
  }

  let makeBody: (Configuration) -> AnyView

  public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

extension ImageStyle {
  public static var `default`: Self {
    .init { $0.content }
  }

  public static func alignment(_ alignment: HorizontalAlignment) -> Self {
    .init { configuration in
      ZStack {
        configuration.content
      }
      .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
    }
  }
}
