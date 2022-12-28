import SwiftUI

public struct BlockStyle<Configuration> {
  private let body: (Configuration) -> AnyView

  public init<Body: View>(@ViewBuilder body: @escaping (_ configuration: Configuration) -> Body) {
    self.body = { AnyView(body($0)) }
  }

  func makeBody(configuration: Configuration) -> AnyView {
    self.body(configuration)
  }
}

extension BlockStyle where Configuration == Void {
  public init<Body: View>(@ViewBuilder body: @escaping () -> Body) {
    self.init { _ in
      body()
    }
  }
}
