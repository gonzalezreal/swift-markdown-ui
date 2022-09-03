import SwiftUI

internal struct InlineGroupTransform {
  var makeBody: (Text) -> Text
}

extension Text {
  func inlineGroupTransform(_ transform: InlineGroupTransform?) -> Text {
    transform?.makeBody(self) ?? self
  }
}
