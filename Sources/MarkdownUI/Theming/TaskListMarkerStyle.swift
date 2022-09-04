import SwiftUI

extension Markdown {
  public struct TaskListMarkerStyle {
    public struct Configuration {
      public var listLevel: Int
      public var checkbox: Checkbox?
    }

    var makeBody: (Configuration) -> Text

    public init(makeBody: @escaping (Configuration) -> Text) {
      self.makeBody = makeBody
    }
  }
}

extension Markdown.TaskListMarkerStyle {
  public static var checkmarkSquare: Self {
    .init { configuration in
      switch configuration.checkbox {
      case .checked:
        return Text(SwiftUI.Image(systemName: "checkmark.square"))
          .foregroundColor(.secondary)
      case .unchecked:
        return Text(SwiftUI.Image(systemName: "square"))
      case .none:
        return Text("")
      }
    }
  }

  public static var checkmarkCircleFill: Self {
    .init { configuration in
      switch configuration.checkbox {
      case .checked:
        return Text(SwiftUI.Image(systemName: "checkmark.circle.fill"))
          .foregroundColor(.accentColor)
      case .unchecked:
        return Text(SwiftUI.Image(systemName: "circle"))
          .foregroundColor(.secondary)
      case .none:
        return Text("")
      }
    }
  }
}
