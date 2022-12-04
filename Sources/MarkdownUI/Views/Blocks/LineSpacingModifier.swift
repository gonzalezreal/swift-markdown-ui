import SwiftUI

private struct LineSpacingModifier: ViewModifier {
  @Environment(\.theme.font.size) private var fontSize

  let lineSpacing: CGFloat

  func body(content: Content) -> some View {
    content
      .lineSpacing(round(self.fontSize * lineSpacing))
  }
}

extension View {
  public func markdownLineSpacing(_ lineSpacing: CGFloat) -> some View {
    self.modifier(LineSpacingModifier(lineSpacing: lineSpacing))
  }
}
