import SwiftUI

extension Markdown {
  public struct TaskListItemStyle {
    public struct Configuration {
      public var label: Text
      public var completed: Bool
    }

    var makeBody: (Configuration) -> Text

    public init(makeBody: @escaping (Configuration) -> Text) {
      self.makeBody = makeBody
    }
  }
}

extension Markdown.TaskListItemStyle {
  public static var plain: Self {
    .init { configuration in
      configuration.label
    }
  }

  public static var strikethroughCompleted: Self {
    .init { configuration in
      configuration.label
        .strikethrough(configuration.completed)
        .foregroundColor(configuration.completed ? .secondary : nil)
    }
  }
}
