import SwiftUI

struct TextTransform {
  var makeBody: (Text) -> Text
}

extension Text {
  func apply(_ transform: TextTransform?) -> Text {
    transform?.makeBody(self) ?? self
  }
}
