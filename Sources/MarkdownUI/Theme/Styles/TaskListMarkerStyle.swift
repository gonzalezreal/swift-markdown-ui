import SwiftUI

public struct TaskListMarkerStyle {
  public struct Configuration {
    public var isCompleted: Bool
  }

  var makeBody: (Configuration) -> AnyView

  public init<Body>(
    @ViewBuilder makeBody: @escaping (_ configuration: Configuration) -> Body
  ) where Body: View {
    self.makeBody = { configuration in
      AnyView(makeBody(configuration))
    }
  }
}

extension TaskListMarkerStyle {
  public static var checkmarkSquareFill: Self {
    .init { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
    }
  }
}
