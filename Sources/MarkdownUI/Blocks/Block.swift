import Foundation
import cmark_gfm

internal struct Block: Hashable {
  enum Content: Hashable {
    case paragraph([Inline])
  }

  var content: Content
  var hasSuccessor: Bool
}

extension Block {
  init?(commonMarkNode: CommonMarkNode) {
    let content: Content

    switch commonMarkNode.type {
    case CMARK_NODE_PARAGRAPH:
      content = .paragraph(commonMarkNode.children.compactMap(Inline.init(commonMarkNode:)))
    default:
      assertionFailure("Unknown block type '\(commonMarkNode.typeString)'")
      return nil
    }

    self.init(content: content, hasSuccessor: commonMarkNode.hasSuccessor)
  }
}
