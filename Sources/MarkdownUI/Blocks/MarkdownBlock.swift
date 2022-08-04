import CommonMark
import SwiftUI

struct MarkdownBlock: View {
  private var block: Block

  init(block: Block) {
    self.block = block
  }

  var body: some View {
    switch block {
    case .blockQuote(let blockQuote):
      MarkdownBlockQuote(content: blockQuote.items)
    case .bulletList(_):
      Text("TODO: implement")
    case .orderedList(_):
      Text("TODO: implement")
    case .code(_):
      Text("TODO: implement")
    case .html(let htmlBlock):
      Text(htmlBlock.html)
    case .paragraph(let paragraph):
      MarkdownInlineGroup(content: paragraph.text)
    case .heading(_):
      Text("TODO: implement")
    case .thematicBreak:
      Divider()
    }
  }
}
