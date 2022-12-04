import SwiftUI

struct HTMLBlockView: View {
  @Environment(\.fontStyle) private var fontStyle

  private let content: String

  init(content: String) {
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
    Text(self.content)
      .font(fontStyle.resolve())
  }
}
