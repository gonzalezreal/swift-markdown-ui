import SwiftUI

public struct BlockStyle {
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  let makeBody: (Label) -> AnyView

  public init<Body: View>(@ViewBuilder makeBody: @escaping (_ label: Label) -> Body) {
    self.makeBody = { label in
      AnyView(makeBody(label))
    }
  }
}

extension BlockStyle {
  public static var defaultImage: BlockStyle {
    self.default
  }

  public static func defaultImage(alignment: HorizontalAlignment) -> BlockStyle {
    BlockStyle { label in
      ZStack {
        label
      }
      .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
    }
  }

  public static var `default`: BlockStyle {
    BlockStyle { label in
      label
        .lineSpacing(.em(0.15))
    }
  }

  public static var defaultBlockquote: BlockStyle {
    BlockStyle { label in
      label
        .markdownFontStyle {
          $0.italic()
        }
        .padding(.leading, .em(2))
        .padding(.trailing, .em(1))
    }
  }

  public static var defaultCodeBlock: BlockStyle {
    BlockStyle { label in
      label.markdownFontStyle {
        $0.monospaced()
      }
      .padding(.leading, .em(1))
      .lineSpacing(.em(0.15))
    }
  }

  public static var defaultHeading1: BlockStyle {
    defaultHeading(level: 1)
  }

  public static var defaultHeading2: BlockStyle {
    defaultHeading(level: 2)
  }

  public static var defaultHeading3: BlockStyle {
    defaultHeading(level: 3)
  }

  public static var defaultHeading4: BlockStyle {
    defaultHeading(level: 4)
  }

  public static var defaultHeading5: BlockStyle {
    defaultHeading(level: 5)
  }

  public static var defaultHeading6: BlockStyle {
    defaultHeading(level: 6)
  }

  private static func defaultHeading(level: Int) -> BlockStyle {
    BlockStyle { label in
      label.markdownFontStyle {
        $0.bold()
          .size(headingSizes[level - 1])
      }
      .markdownBlockSpacing(top: .rem(1.5))
    }
  }

  public static var defaultThematicBreak: BlockStyle {
    BlockStyle { _ in
      Divider()
        .markdownBlockSpacing(top: .rem(2), bottom: .rem(2))
    }
  }
}

private let headingSizes: [Size] = [
  .em(2), .em(1.5), .em(1.17),
  .em(1), .em(0.83), .em(0.67),
]
