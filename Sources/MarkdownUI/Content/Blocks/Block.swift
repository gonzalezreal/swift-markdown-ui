import Foundation
@_implementationOnly import cmark_gfm

enum Block: Hashable {
  case blockquote([Block])
  case taskList(tight: Bool, items: [TaskListItem])
  case bulletedList(tight: Bool, items: [ListItem])
  case numberedList(tight: Bool, start: Int, items: [ListItem])
  case paragraph([Inline])
  case heading(level: Int, text: [Inline])
}

extension Block {
  init?(node: CommonMarkNode) {
    switch node.type {
    case CMARK_NODE_BLOCK_QUOTE:
      self = .blockquote(node.children.compactMap(Block.init(node:)))
    case CMARK_NODE_LIST where node.hasTaskItems:
      self = .taskList(
        tight: node.listTight,
        items: node.children.compactMap(TaskListItem.init(node:))
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
    case CMARK_NODE_HEADING:
      self = .heading(level: node.headingLevel, text: node.children.compactMap(Inline.init(node:)))
    default:
      assertionFailure("Unknown block type '\(node.typeString)'")
      return nil
    }
  }

  var isParagraph: Bool {
    guard case .paragraph = self else { return false }
    return true
  }
}

extension Array where Element == Block {
  init(markdown: String) {
    let node = CommonMarkNode(markdown: markdown, extensions: .all, options: CMARK_OPT_DEFAULT)
    let blocks = node?.children.compactMap(Block.init(node:)) ?? []

    self.init(blocks)
  }
}

extension ListItem {
  init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(blocks: .init(node.children.compactMap(Block.init(node:))))
  }
}

extension TaskListItem {
  init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(
      isCompleted: node.isTaskListItemChecked,
      blocks: .init(node.children.compactMap(Block.init(node:)))
    )
  }
}
