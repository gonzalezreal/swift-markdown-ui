import SwiftUI

private struct MinWidthModifier: ViewModifier {
  @Environment(\.theme.font.baseSize) private var baseFontSize

  let minWidth: CGFloat
  let alignment: HorizontalAlignment

  func body(content: Content) -> some View {
    content.frame(
      minWidth: round(self.minWidth * self.baseFontSize),
      alignment: .init(horizontal: self.alignment, vertical: .center)
    )
  }
}

extension View {
  public func markdownMinWidth(
    _ minWidth: CGFloat,
    alignment: HorizontalAlignment = .center
  ) -> some View {
    self.modifier(MinWidthModifier(minWidth: minWidth, alignment: alignment))
  }
}
