import SwiftUI

private struct SpacingPreference: PreferenceKey {
  static let defaultValue: CGFloat = Font.TextStyle.body.pointSize

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

extension View {
  public func spacingPreference(_ value: CGFloat?) -> some View {
    self.transformPreference(SpacingPreference.self) { spacing in
      spacing = value ?? spacing
    }
  }

  func onSpacingPreferenceChange(perform action: @escaping (CGFloat) -> Void) -> some View {
    self.onPreferenceChange(SpacingPreference.self, perform: action)
  }
}
