import SwiftUI

public struct TaskListMarkerStyleConfiguration {
  public var listLevel: Int
  public var checkbox: Checkbox?
}

public typealias TaskListMarkerStyle = ListMarkerStyle<TaskListMarkerStyleConfiguration>

extension TaskListMarkerStyle {
  public static func checkmarkCircle(color: Color?) -> Self {
    .init { configuration in
      Image(checkbox: configuration.checkbox)
        .foregroundColor(configuration.checkbox == .checked ? color : nil)
    }
  }
}

extension Image {
  fileprivate init(checkbox: Checkbox?) {
    switch checkbox {
    case .checked:
      self.init(systemName: "checkmark.circle")
    case .unchecked, .none:
      self.init(systemName: "circle")
    }
  }
}
