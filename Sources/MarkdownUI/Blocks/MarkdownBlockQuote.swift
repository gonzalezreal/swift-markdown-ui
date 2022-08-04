import CommonMark
import SwiftUI

struct MarkdownBlockQuote: View {
  @Environment(\.font) private var font

  private var content: [Block]

  init(content: [Block]) {
    self.content = content
  }

  var body: some View {
    MarkdownBlockGroup(content: content)
      .font((font ?? .body).italic())
      .padding(.leading)
      .padding(.horizontal)
  }
}
