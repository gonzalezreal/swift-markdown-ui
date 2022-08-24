import Foundation
import cmark_gfm

internal struct Block: Hashable {
  enum Content: Hashable {
    case paragraph([Inline])
  }

  var id: Int
  var hasSuccessor: Bool
  var content: Content
}

extension Block {
  init?(commonMarkNode: CommonMarkNode, makeId: () -> Int) {
    let content: Content

    switch commonMarkNode.type {
    case CMARK_NODE_PARAGRAPH:
      content = .paragraph(commonMarkNode.children.compactMap(Inline.init(commonMarkNode:)))
    default:
      assertionFailure("Unknown block type '\(commonMarkNode.typeString)'")
      return nil
    }

    self.init(id: makeId(), hasSuccessor: commonMarkNode.hasSuccessor, content: content)
  }
}
