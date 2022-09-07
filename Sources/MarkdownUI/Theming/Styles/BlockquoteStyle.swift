import SwiftUI

extension Markdown {
  public struct BlockquoteStyle {
    public struct Configuration {
      public typealias Label = AnyView

      public var label: Label
      public var font: Font?
      public var textAlignment: TextAlignment
      public var indentSize: CGFloat
    }

    var makeBody: (Configuration) -> AnyView

    public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
      self.makeBody = { configuration in
        AnyView(makeBody(configuration))
      }
    }
  }
}

extension Markdown.BlockquoteStyle {
  public static var indentedItalic: Self {
    .init { configuration in
      configuration.label
        .font(configuration.font?.italic())
        .padding(.leading, configuration.indentSize)
        .padding(.trailing, configuration.indentSize / 2)
    }
  }
}
