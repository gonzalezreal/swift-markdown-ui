import SwiftUI

private struct BlockSpacingModifier: ViewModifier {
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @State private var blockSpacing: CGFloat = 0

  let enabled: Bool

  func body(content: Content) -> some View {
    content
      .onPreferenceChange(BlockSpacingPreference.self) { value in
        self.blockSpacing = value
      }
      .padding(.bottom, (enabled && !tightSpacingEnabled) ? blockSpacing : 0)
  }
}

extension View {
  func blockSpacing(enabled: Bool = true) -> some View {
    modifier(BlockSpacingModifier(enabled: enabled))
  }
}
