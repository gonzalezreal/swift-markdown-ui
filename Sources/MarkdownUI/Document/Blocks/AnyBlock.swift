import Foundation
@_implementationOnly import cmark_gfm

public enum AnyBlock: Hashable {
  case paragraph([AnyInline])
}

extension AnyBlock {
  init?(node: CommonMarkNode) {
    switch node.type {
    case CMARK_NODE_PARAGRAPH:
      self = .paragraph(node.children.compactMap(AnyInline.init(node:)))
    default:
      assertionFailure("Unknown block type '\(node.typeString)'")
      return nil
    }
  }

  var inlines: [AnyInline] {
    switch self {
    case .paragraph(let inlines):
      return inlines
    }
  }
}

extension Array where Element == AnyBlock {
  init(markdown: String) {
    let node = CommonMarkNode(markdown: markdown, extensions: .all, options: CMARK_OPT_DEFAULT)
    let blocks = node?.children.compactMap(AnyBlock.init(node:)) ?? []

    self.init(blocks)
  }

  var inlines: [AnyInline] {
    flatMap(\.inlines)
  }
}
