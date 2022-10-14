import SwiftUI

struct CollectSizePreference<K>: PreferenceKey where K: Hashable {
  static var defaultValue: [K: CGSize] { [:] }

  static func reduce(value: inout [K: CGSize], nextValue: () -> [K: CGSize]) {
    value.merge(nextValue(), uniquingKeysWith: { $1 })
  }
}

extension View {
  func collectSize<K>(key: K) -> some View where K: Hashable {
    self.background(
      GeometryReader { proxy in
        Color.clear.preference(
          key: CollectSizePreference<K>.self,
          value: [key: proxy.size]
        )
      }
    )
  }
}
