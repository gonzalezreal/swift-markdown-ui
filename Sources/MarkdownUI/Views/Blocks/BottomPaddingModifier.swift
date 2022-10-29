import SwiftUI

private struct BottomPaddingModifier: ViewModifier {
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @State private var bottomPadding: CGFloat = 0

  let enabled: Bool

  func body(content: Content) -> some View {
    content
      .onPreferenceChange(BottomPaddingPreference.self) { value in
        self.bottomPadding = value
      }
      .padding(.bottom, (enabled && !tightSpacingEnabled) ? bottomPadding : 0)
  }
}

extension View {
  func bottomPadding(enabled: Bool = true) -> some View {
    modifier(BottomPaddingModifier(enabled: enabled))
  }
}
