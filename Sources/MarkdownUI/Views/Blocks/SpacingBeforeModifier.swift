import SwiftUI

private struct SpacingBeforeModifier: ViewModifier {
  @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1
  @State private var spacingBefore: CGFloat = 0

  let enabled: Bool

  func body(content: Content) -> some View {
    content
      .onSpacingBeforePreferenceChange { value in
        self.spacingBefore = value
      }
      .padding(.top, self.enabled ? self.spacingBefore * self.scale : 0)
  }
}

extension View {
  func spacingBefore(enabled: Bool = true) -> some View {
    modifier(SpacingBeforeModifier(enabled: enabled))
  }
}
