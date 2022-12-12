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
