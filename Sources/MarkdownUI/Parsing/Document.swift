import Foundation
import cmark_gfm

internal struct Document: Hashable {
  let blocks: [Block]

  init(blocks: [Block]) {
    self.blocks = blocks
  }

  init(markdown: String) {
    let node = CommonMarkNode(markdown: markdown, extensions: .all, options: 0)
    let blocks = node?.children.compactMap(Block.init(commonMarkNode:)) ?? []

    self.init(blocks: blocks)
  }
}
