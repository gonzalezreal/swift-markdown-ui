import SwiftUI

private struct ScaledMinWidthModifier: ViewModifier {
  @ScaledMetric private var minWidth: CGFloat
  private let alignment: Alignment

  init(minWidth: CGFloat, relativeTo textStyle: Font.TextStyle, alignment: Alignment) {
    self._minWidth = ScaledMetric(wrappedValue: minWidth, relativeTo: textStyle)
    self.alignment = alignment
  }

  func body(content: Content) -> some View {
    return
      content
      .frame(minWidth: self.minWidth, alignment: self.alignment)
  }
}

extension View {
  public func scaledMinWidth(
    _ minWidth: CGFloat,
    relativeTo textStyle: Font.TextStyle = .body,
    alignment: Alignment = .center
  ) -> some View {
    self.modifier(
      ScaledMinWidthModifier(minWidth: minWidth, relativeTo: textStyle, alignment: alignment)
    )
  }
}
