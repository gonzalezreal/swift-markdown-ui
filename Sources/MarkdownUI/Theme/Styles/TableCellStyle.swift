import SwiftUI

public struct TableCellStyle {
  public struct Configuration {
    public struct Label: View {
      init<L: View>(_ label: L) {
        self.body = AnyView(label)
      }

      public let body: AnyView
    }

    public let row: Int
    public let column: Int
    public let label: Label
  }

  let makeBody: (Configuration) -> AnyView

  public init<Body: View>(makeBody: @escaping (Configuration) -> Body) {
    self.makeBody = { AnyView(makeBody($0)) }
  }
}

extension TableCellStyle {
  public static var `default`: TableCellStyle {
    TableCellStyle { configuration in
      configuration.label
        .markdownFontStyle { fontStyle in
          configuration.row == 0 ? fontStyle.bold() : fontStyle
        }
        .padding(.horizontal, .em(0.72))
        .padding(.vertical, .em(0.35))
    }
  }
}
