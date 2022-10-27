import Foundation

public struct ListItem: Hashable {
  let blocks: [Block]

  init(blocks: [Block]) {
    self.blocks = blocks
  }

  init(_ text: String) {
    self.init(blocks: [.paragraph([.text(text)])])
  }

  public init(@MarkdownContentBuilder content: () -> MarkdownContent) {
    self.init(blocks: content().blocks)
  }
}
