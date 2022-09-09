import SwiftUI

public struct ListMarkerStyle<Configuration> {
  var makeBody: (Configuration) -> AnyView

  public init<Body>(
    @ViewBuilder makeBody: @escaping (_ configuration: Configuration) -> Body
  ) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}
