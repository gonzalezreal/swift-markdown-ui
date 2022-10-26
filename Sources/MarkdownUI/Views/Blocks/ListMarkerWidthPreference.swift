import SwiftUI

struct ListMarkerWidthPreference: PreferenceKey {
  static let defaultValue: CGFloat? = nil

  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    value = max(value ?? 0, nextValue() ?? 0)
  }
}

extension View {
  func readListMarkerWidth() -> some View {
    background(
      GeometryReader { proxy in
        Color.clear.preference(key: ListMarkerWidthPreference.self, value: proxy.size.width)
      }
    )
  }
}
