import SwiftUI

private struct SpacingModifier: ViewModifier {
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1
  @State private var spacing: CGFloat = 0

  let enabled: Bool

  private var length: CGFloat {
    (self.enabled && !self.tightSpacingEnabled) ? self.spacing * self.scale : 0
  }

  func body(content: Content) -> some View {
    content
      .onSpacingPreferenceChange { value in
        self.spacing = value
      }
      .padding(.bottom, self.length)
  }
}

extension View {
  func spacing(enabled: Bool = true) -> some View {
    modifier(SpacingModifier(enabled: enabled))
  }
}
