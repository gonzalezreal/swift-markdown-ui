import SwiftUI

internal struct ListMarkerView<Content: View>: View {
  @ScaledMetric private var minWidth: CGFloat

  private var content: Content

  init(content: Content, minWidth: CGFloat) {
    self.content = content
    self._minWidth = .init(wrappedValue: minWidth, relativeTo: .body)
  }

  var body: some View {
    content
      .frame(minWidth: minWidth - (minWidth / 4), alignment: .trailing)
      .padding(.trailing, minWidth / 4)
  }
}
