import SwiftUI
import cmark_gfm

enum Block {
  case blockquote([Block])
  case bulletedList(tight: Bool, items: [ListItem<_BlockSequence<Block>>])
  case numberedList(tight: Bool, start: Int, items: [ListItem<_BlockSequence<Block>>])
  case taskList(tight: Bool, items: [ListItem<_BlockSequence<Block>>])
  case paragraph([Inline])
}

extension Block {
  init?(node: CommonMarkNode) {
    switch node.type {
    case CMARK_NODE_BLOCK_QUOTE:
      self = .blockquote(node.children.compactMap(Block.init(node:)))
    case CMARK_NODE_LIST where node.hasTaskItems:
      self = .taskList(
        tight: node.listTight,
        items: node.children.compactMap(ListItem.init(node:))
      )
    case CMARK_NODE_LIST where node.listType == CMARK_BULLET_LIST:
      self = .bulletedList(
        tight: node.listTight,
        items: node.children.compactMap(ListItem.init(node:))
      )
    case CMARK_NODE_LIST where node.listType == CMARK_ORDERED_LIST:
      self = .numberedList(
        tight: node.listTight,
        start: node.listStart,
        items: node.children.compactMap(ListItem.init(node:))
      )
    case CMARK_NODE_PARAGRAPH:
      self = .paragraph(node.children.compactMap(Inline.init(node:)))
    default:
      assertionFailure("Unknown block type '\(node.typeString)'")
      return nil
    }
  }
}

extension Block: BlockContent {
  var body: some View {
    switch self {
    case .blockquote(let blocks):
      Blockquote(blocks: blocks)
    case .bulletedList(let tight, let items):
      BulletedList(tight: tight, items: items)
    case .numberedList(let tight, let start, let items):
      NumberedList(tight: tight, start: start, items: items)
    case .taskList(let tight, let items):
      TaskList(tight: tight, items: items)
    case .paragraph(let inlines):
      Paragraph(inlines: inlines)
    }
  }
}
