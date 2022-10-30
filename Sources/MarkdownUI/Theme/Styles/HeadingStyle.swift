import SwiftUI

public struct HeadingStyle {
  public struct Configuration {
    public struct Label: View {
      init<C: View>(_ content: C) {
        self.body = AnyView(content)
      }

      public let body: AnyView
    }

    public let label: Label
  }

  let makeBody: (Configuration) -> AnyView

  public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

extension HeadingStyle {
  public static func font(_ font: Font) -> Self {
    .init { configuration in
      configuration.label
        .font(font)
    }
  }
}
