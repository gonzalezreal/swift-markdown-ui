import SwiftUI

private struct FontSizeModifier: ViewModifier {
  @ScaledMetric private var size: CGFloat

  init(size: CGFloat, textStyle: Font.TextStyle) {
    self._size = ScaledMetric(wrappedValue: size, relativeTo: textStyle)
  }

  func body(content: Content) -> some View {
    content.transformEnvironment(\.theme.font) {
      $0.baseSize = self.size
    }
  }
}

extension View {
  func fontSize(_ size: CGFloat, relativeTo textStyle: Font.TextStyle) -> some View {
    self.modifier(FontSizeModifier(size: size, textStyle: textStyle))
  }
}
