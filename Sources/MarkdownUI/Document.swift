import Foundation
import cmark_gfm

internal struct Document: Hashable {
  let blocks: [Block]

  init(blocks: [Block]) {
    self.blocks = blocks
  }

  init(markdown: String) {
    let makeId = Int.incrementingId
    let node = CommonMarkNode(markdown: markdown, extensions: .all, options: CMARK_OPT_DEFAULT)
    let blocks = node?.children.compactMap { node in
      Block(commonMarkNode: node, makeId: makeId)
    }

    self.init(blocks: blocks ?? [])
  }
}

extension Int {
  fileprivate static var incrementingId: () -> Int {
    var value = 1
    return {
      defer { value += 1 }
      return value
    }
  }
}
