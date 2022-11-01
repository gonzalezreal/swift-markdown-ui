import SwiftUI

private struct SpacingBeforePreference: PreferenceKey {
  static let defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

extension View {
  public func spacingBeforePreference(_ value: CGFloat?) -> some View {
    self.transformPreference(SpacingBeforePreference.self) { spacingBefore in
      spacingBefore = value ?? spacingBefore
    }
  }

  func onSpacingBeforePreferenceChange(perform action: @escaping (CGFloat) -> Void) -> some View {
    self.onPreferenceChange(SpacingBeforePreference.self, perform: action)
  }
}
