import SwiftUI

public struct BlockConfiguration {
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  public let label: Label
}

extension BlockStyle where Configuration == BlockConfiguration {
  public init<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) {
    self.init { configuration in
      body(configuration.label)
    }
  }

  public init() {
    self.init { $0 }
  }
}
