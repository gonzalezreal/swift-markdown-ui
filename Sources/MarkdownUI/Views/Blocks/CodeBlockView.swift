import SwiftUI

struct CodeBlockView: View {
  private let info: String?
  private let content: String

  init(info: String?, content: String) {
    self.info = info
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
    Text(self.content)
      .markdownFont()
  }
}
