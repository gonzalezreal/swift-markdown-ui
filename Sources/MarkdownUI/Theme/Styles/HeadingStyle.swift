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
  public static var largeTitle: Self {
    .init { configuration in
      configuration.label
        .font(.largeTitle)
    }
  }

  public static var title: Self {
    .init { configuration in
      configuration.label
        .font(.title)
    }
  }

  public static var title2: Self {
    .init { configuration in
      configuration.label
        .font(.title2)
    }
  }

  public static var title3: Self {
    .init { configuration in
      configuration.label
        .font(.title3)
    }
  }

  public static var headline: Self {
    .init { configuration in
      configuration.label
        .font(.headline)
    }
  }

  public static var subheadline: Self {
    .init { configuration in
      configuration.label
        .font(.subheadline)
    }
  }
}
