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
  public static func defaultImage(
    horizontalSpacing: CGFloat? = nil,
    verticalSpacing: CGFloat? = nil
  ) -> BlockStyle {
    BlockStyle { label in
      label
        .imageSpacingPreference(horizontal: horizontalSpacing, vertical: verticalSpacing)
    }
  }

  public static func alignedImage(
    _ alignment: HorizontalAlignment,
    horizontalSpacing: CGFloat? = nil,
    verticalSpacing: CGFloat? = nil
  ) -> BlockStyle {
    BlockStyle { label in
      ZStack {
        label
      }
      .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
      .imageSpacingPreference(horizontal: horizontalSpacing, vertical: verticalSpacing)
    }
  }

  public static func `default`(
    spacing: CGFloat? = nil,
    spacingBefore: CGFloat? = nil
  ) -> BlockStyle {
    BlockStyle { label in
      label
        .spacingPreference(spacing)
        .spacingBeforePreference(spacingBefore)
    }
  }

  public static func defaultBlockquote(
    spacing: CGFloat? = nil,
    spacingBefore: CGFloat? = nil
  ) -> BlockStyle {
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
        .spacingPreference(spacing)
        .spacingBeforePreference(spacingBefore)
    }
  }

  public static func defaultHeading(
    font: Font,
    spacing: CGFloat? = nil,
    spacingBefore: CGFloat? = nil
  ) -> BlockStyle {
    BlockStyle { label in
      label.font(font)
        .spacingPreference(spacing)
        .spacingBeforePreference(spacingBefore ?? Font.TextStyle.body.pointSize / 2)
    }
  }
}
