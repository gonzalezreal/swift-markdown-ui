import SwiftUI

public struct TaskListItemConfiguration {
  public var isCompleted: Bool
}

extension BlockStyle where Configuration == TaskListItemConfiguration {
  public static var checkmarkSquare: Self {
    BlockStyle { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }
}
