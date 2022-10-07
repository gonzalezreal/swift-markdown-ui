import SwiftUI

public struct ImageStyle {
  public struct Configuration {
    public let content: SwiftUI.Image
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
      ResponsiveImage(image: configuration.content, idealSize: configuration.contentSize)
    }
  }

  public static func responsive(alignment: HorizontalAlignment) -> Self {
    .init { configuration in
      ResponsiveImage(image: configuration.content, idealSize: configuration.contentSize)
        .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
    }
  }
}
