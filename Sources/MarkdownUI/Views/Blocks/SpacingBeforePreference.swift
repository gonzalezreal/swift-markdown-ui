import SwiftUI

private struct SpacingBeforePreference: PreferenceKey {
  static let defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

extension View {
  public func spacingBeforePreference(_ value: CGFloat) -> some View {
    self.preference(key: SpacingBeforePreference.self, value: value)
  }

  func onSpacingBeforePreferenceChange(perform action: @escaping (CGFloat) -> Void) -> some View {
    self.onPreferenceChange(SpacingBeforePreference.self, perform: action)
  }
}
