import SwiftUI

public struct TaskListMarkerStyleConfiguration {
  public var listLevel: Int
  public var checkbox: Checkbox?
}

public typealias TaskListMarkerStyle = ListMarkerStyle<TaskListMarkerStyleConfiguration>

extension TaskListMarkerStyle {
  public static var empty: Self {
    .init { _ in
      EmptyView()
    }
  }

  public static var checkmarkSquareFill: Self {
    .init { configuration in
      Image(checkbox: configuration.checkbox, checked: "checkmark.square.fill", unchecked: "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
    }
  }
}

extension Image {
  fileprivate init(checkbox: Checkbox?, checked: String, unchecked: String) {
    switch checkbox {
    case .checked:
      self.init(systemName: checked)
    case .unchecked, .none:
      self.init(systemName: unchecked)
    }
  }
}
