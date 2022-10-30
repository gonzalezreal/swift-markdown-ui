import SwiftUI

private struct TopPaddingModifier: ViewModifier {
  @State private var topPadding: CGFloat = 0

  let enabled: Bool

  func body(content: Content) -> some View {
    content
      .onPreferenceChange(TopPaddingPreference.self) { value in
        self.topPadding = value
      }
      .padding(.top, self.enabled ? self.topPadding : 0)
  }
}

extension View {
  func topPadding(enabled: Bool = true) -> some View {
    modifier(TopPaddingModifier(enabled: enabled))
  }
}
