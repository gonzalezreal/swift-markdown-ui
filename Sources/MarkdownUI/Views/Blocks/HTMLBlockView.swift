import SwiftUI

struct HTMLBlockView: View {
  private let content: String

  init(content: String) {
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
    Text(self.content)
      .textStyleFont()
  }
}
