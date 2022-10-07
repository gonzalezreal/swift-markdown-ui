import SwiftUI

public struct BlockquoteStyle {
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

extension BlockquoteStyle {
  private struct IndentItalicView: View {
    @Environment(\.font) private var font
    let configuration: Configuration

    var body: some View {
      configuration.content
        .font(font?.italic())
        .padding(.leading)
        .padding(.leading)
        .padding(.trailing)
    }
  }

  public static var indentItalic: Self {
    .init { configuration in
      IndentItalicView(configuration: configuration)
    }
  }
}
