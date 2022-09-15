import SwiftUI

struct ColumnWidthPreference: PreferenceKey {
  static let defaultValue: [Int: CGFloat] = [:]

  static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
    value.merge(nextValue(), uniquingKeysWith: max)
  }
}

extension View {
  func columnWidthPreference(_ column: Int) -> some View {
    background(
      GeometryReader { proxy in
        Color.clear.preference(key: ColumnWidthPreference.self, value: [column: proxy.size.width])
      }
    )
  }
}
