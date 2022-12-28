import SwiftUI

public struct Old_BlockStyle {
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

extension Old_BlockStyle {
  public static var unit: Old_BlockStyle {
    Old_BlockStyle { $0 }
  }
}
