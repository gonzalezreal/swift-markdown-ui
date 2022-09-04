import SwiftUI

extension Markdown {
  public struct TaskListMarkerStyle {
    public struct Configuration {
      public var listLevel: Int
      public var checkbox: Checkbox?
    }

    var makeBody: (Configuration) -> AnyView

    public init<Body>(@ViewBuilder makeBody: @escaping (Configuration) -> Body) where Body: View {
      self.makeBody = { configuration in
        AnyView(makeBody(configuration))
      }
    }
  }
}

extension Markdown.TaskListMarkerStyle {
  public static func checkmarkCircle(color: Color?) -> Self {
    .init { configuration in
      SwiftUI.Image(checkbox: configuration.checkbox)
        .foregroundColor(configuration.checkbox == .checked ? color : nil)
    }
  }
}

extension SwiftUI.Image {
  fileprivate init(checkbox: Checkbox?) {
    switch checkbox {
    case .checked:
        self.init(systemName: "checkmark.circle")
    case .unchecked, .none:
      self.init(systemName: "circle")
    }
  }
}
