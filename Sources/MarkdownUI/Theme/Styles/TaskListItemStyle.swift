import SwiftUI

public struct TaskListItemStyle {
  public struct Configuration {
    public var text: Text
    public var isCompleted: Bool
  }

  var makeBody: (Configuration) -> Text

  public init(makeBody: @escaping (Configuration) -> Text) {
    self.makeBody = makeBody
  }
}

extension TaskListItemStyle {
  public static var `default`: Self {
    .init { configuration in
      configuration.text
    }
  }

  public static var strikethroughCompleted: Self {
    .init { configuration in
      configuration.text
        .strikethrough(configuration.isCompleted)
        .foregroundColor(configuration.isCompleted ? .secondary : nil)
    }
  }
}
