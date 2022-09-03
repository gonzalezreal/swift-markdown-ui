import SwiftUI

internal struct ListMarkerView: View {
  private var content: Text
  @ScaledMetric private var minWidth: CGFloat

  init(content: Text, minWidth: CGFloat) {
    self.content = content
    self._minWidth = .init(wrappedValue: minWidth, relativeTo: .body)
  }

  var body: some View {
    content
      .monospacedDigit()
      .frame(minWidth: minWidth - (minWidth / 4), alignment: .trailing)
      .padding(.trailing, minWidth / 4)
  }
}
