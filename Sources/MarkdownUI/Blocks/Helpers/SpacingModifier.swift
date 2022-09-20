import SwiftUI

private struct SpacingModifier: ViewModifier {
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @State private var spacing: CGFloat = 0

  let enabled: Bool

  func body(content: Content) -> some View {
    content
      .onPreferenceChange(SpacingPreference.self) { spacing in
        self.spacing = spacing
      }
      .padding(.bottom, (enabled && !tightSpacingEnabled) ? spacing : 0)
  }
}

extension View {
  func spacing(enabled: Bool = true) -> some View {
    modifier(SpacingModifier(enabled: enabled))
  }
}
