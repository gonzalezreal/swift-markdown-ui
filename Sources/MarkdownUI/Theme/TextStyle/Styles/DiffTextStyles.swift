import SwiftUI

/// A text style for diff deleted text (red with strikethrough).
struct DiffDeletedTextStyle: TextStyle {
  func _collectAttributes(in attributes: inout AttributeContainer) {
    ForegroundColor(.red)._collectAttributes(in: &attributes)
    StrikethroughStyle(.single)._collectAttributes(in: &attributes)
  }
}

/// A text style for diff inserted text (green).
struct DiffInsertedTextStyle: TextStyle {
  func _collectAttributes(in attributes: inout AttributeContainer) {
    ForegroundColor(.green)._collectAttributes(in: &attributes)
  }
}
