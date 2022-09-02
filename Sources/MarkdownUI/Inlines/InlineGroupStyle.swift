import SwiftUI

internal struct InlineGroupStyle {
  struct Configuration {
    var label: Text
  }

  var makeBody: (Configuration) -> Text
}

extension Text {
  func inlineGroupStyle(_ inlineGroupStyle: InlineGroupStyle?) -> Text {
    inlineGroupStyle?.makeBody(.init(label: self)) ?? self
  }
}
