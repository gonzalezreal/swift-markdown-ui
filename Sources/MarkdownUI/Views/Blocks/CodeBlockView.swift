import SwiftUI

struct CodeBlockView: View {
  @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter

  private let fenceInfo: String?
  private let content: String

  init(fenceInfo: String?, content: String) {
    self.fenceInfo = fenceInfo
    self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
  }

  var body: some View {
    self.codeSyntaxHighlighter.highlightCode(self.content, language: self.fenceInfo)
      .textStyleFont()
  }
}
