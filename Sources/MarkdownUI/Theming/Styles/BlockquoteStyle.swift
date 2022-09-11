import SwiftUI

public struct BlockquoteStyle {
  public struct Configuration {
    public struct Content: View {
      private var blockGroup: BlockGroup

      init(_ blockGroup: BlockGroup) {
        self.blockGroup = blockGroup
      }

      public var body: some View {
        // Remove the last paragraph spacing before applying the style
        blockGroup.paragraphSpacing(scaleFactor: -1)
      }
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
