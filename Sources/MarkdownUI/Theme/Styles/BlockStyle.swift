import SwiftUI

public struct BlockStyle {
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  let makeBody: (Label) -> AnyView

  public init<Body: View>(@ViewBuilder makeBody: @escaping (Label) -> Body) {
    self.makeBody = { label in
      AnyView(makeBody(label))
    }
  }
}

extension BlockStyle {
  public static var defaultImage: BlockStyle {
    BlockStyle { label in
      label.imageSpacing()
    }
  }

  public static func defaultImage(alignment: HorizontalAlignment) -> BlockStyle {
    BlockStyle { label in
      ZStack {
        label
      }
      .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
      .imageSpacing()
    }
  }

  public static var `default`: BlockStyle {
    BlockStyle { label in
      label
        .blockSpacing()
    }
  }

  public static var defaultBlockquote: BlockStyle {
    struct DefaultBlockquote: View {
      @Environment(\.font) private var font
      let label: Label

      var body: some View {
        self.label
          .font(self.font?.italic())
          .padding(.leading)
          .padding(.leading)
          .padding(.trailing)
      }
    }

    return BlockStyle {
      DefaultBlockquote(label: $0)
    }
  }

  public static var defaultHeading1: BlockStyle {
    defaultHeading(font: .largeTitle.weight(.medium))
  }

  public static var defaultHeading2: BlockStyle {
    defaultHeading(font: .title.weight(.medium))
  }

  public static var defaultHeading3: BlockStyle {
    defaultHeading(font: .title2.weight(.medium))
  }

  public static var defaultHeading4: BlockStyle {
    defaultHeading(font: .title3.weight(.medium))
  }

  public static var defaultHeading5: BlockStyle {
    defaultHeading(font: .headline)
  }

  public static var defaultHeading6: BlockStyle {
    defaultHeading(font: .subheadline.weight(.medium))
  }

  private static func defaultHeading(font: Font) -> BlockStyle {
    BlockStyle { label in
      label.font(font)
        .blockSpacing(top: Font.TextStyle.body.pointSize * 1.5)
    }
  }
}
