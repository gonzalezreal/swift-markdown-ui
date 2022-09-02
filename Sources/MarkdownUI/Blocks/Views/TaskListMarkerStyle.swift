import SwiftUI

public struct TaskListMarkerStyle {
  public struct Configuration {
    public var checkbox: Checkbox?
  }

  var makeBody: (Configuration) -> Text

  public init(makeBody: @escaping (Configuration) -> Text) {
    self.makeBody = makeBody
  }
}

extension TaskListMarkerStyle {
  public static var square: Self {
    .init { configuration in
      Text(configuration.checkbox)
        .foregroundColor(configuration.checkbox?.foregroundColor)
    }
  }
}

extension Text {
  init(_ checkbox: Checkbox?) {
    switch checkbox {
    case .checked:
      self.init(SwiftUI.Image(systemName: "checkmark.square"))
    case .unchecked:
      self.init(SwiftUI.Image(systemName: "square"))
    case .none:
      self.init("")
    }
  }
}

extension Checkbox {
  fileprivate var foregroundColor: Color? {
    guard case .checked = self else {
      return nil
    }
    return .secondary
  }
}
