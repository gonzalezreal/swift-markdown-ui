import SwiftUI

public struct BlockquoteStyle {
  public struct Configuration {
    public struct Content: View {
      init<C: View>(_ content: C) {
        self.body = AnyView(content)
      }

      public let body: AnyView
    }

    public var content: Content
    public var font: Font?
    public var textAlignment: TextAlignment
  }

  var makeBody: (Configuration) -> AnyView

  public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

extension BlockquoteStyle {
  public static var indentItalic: Self {
    .init { configuration in
      configuration.content
        .font(configuration.font?.italic())
        .padding(.leading)
        .padding(.leading)
        .padding(.trailing)
    }
  }
}
