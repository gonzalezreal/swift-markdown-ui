import SwiftUI

internal struct ListMarkerView<Content: View>: View {
  @Environment(\.theme.indentSize) private var indentSize

  private var content: Content

  init(content: Content) {
    self.content = content
  }

  var body: some View {
    content
      .frame(minWidth: indentSize - (indentSize / 4), alignment: .trailing)
      .padding(.trailing, indentSize / 4)
  }
}
