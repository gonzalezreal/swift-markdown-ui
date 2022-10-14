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
    public let contentSize: CGSize
  }

  let makeBody: (Configuration) -> AnyView

  public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

extension ImageStyle {
  public static var responsive: Self {
    .init { configuration in
      ResponsiveImage(imageContent: configuration.content, idealSize: configuration.contentSize)
    }
  }

  public static func responsive(alignment: HorizontalAlignment) -> Self {
    .init { configuration in
      ResponsiveImage(imageContent: configuration.content, idealSize: configuration.contentSize)
        .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
    }
  }
}
