import CommonMark
import SwiftUI

struct MarkdownBlockQuote: View {
  @Environment(\.markdownBlockQuoteStyle) private var style
  @Environment(\.font) private var font

  private var content: [Block]

  init(content: [Block]) {
    self.content = content
  }

  var body: some View {
    style.makeBody(
      configuration: .init(
        label: .init(MarkdownBlockGroup(content: content)),
        font: font
      )
    )
  }
}
