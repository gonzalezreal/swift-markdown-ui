import SwiftUI

struct CodeBlockView: View {
  @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter

  private let info: String?
  private let content: String

  init(info: String?, content: String) {
    self.info = info
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
    self.codeSyntaxHighlighter.highlightCode(self.content, language: self.info)
      .textStyleFont()
  }
}
