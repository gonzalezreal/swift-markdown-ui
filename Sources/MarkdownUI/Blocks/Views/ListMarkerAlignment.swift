import SwiftUI

extension HorizontalAlignment {
  private struct ListMarkerAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[HorizontalAlignment.leading]
    }
  }

  static let listMarkerAlignment = HorizontalAlignment(ListMarkerAlignment.self)
}
