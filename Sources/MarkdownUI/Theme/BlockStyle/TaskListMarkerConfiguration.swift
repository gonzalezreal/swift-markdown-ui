import SwiftUI

public struct TaskListMarkerConfiguration {
  public var isCompleted: Bool
}

extension BlockStyle where Configuration == TaskListMarkerConfiguration {
  public static var checkmarkSquare: Self {
    BlockStyle { configuration in
      SwiftUI.Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .imageScale(.small)
        .frame(minWidth: .em(1.5), alignment: .trailing)
    }
  }
}
