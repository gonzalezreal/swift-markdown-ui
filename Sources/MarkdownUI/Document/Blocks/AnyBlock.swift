import Foundation
@_implementationOnly import cmark_gfm

public enum AnyBlock: Hashable {
  case taskList(tight: Bool, items: [TaskListItem])
  case bulletedList(tight: Bool, items: [ListItem])
  case numberedList(tight: Bool, start: Int, items: [ListItem])
  case paragraph([AnyInline])
}

extension AnyBlock {
  init?(node: CommonMarkNode) {
    switch node.type {
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
      self = .paragraph(node.children.compactMap(AnyInline.init(node:)))
    default:
      assertionFailure("Unknown block type '\(node.typeString)'")
      return nil
    }
  }

  var inlines: [AnyInline] {
    switch self {
    case .taskList(_, let items):
      return items.flatMap(\.blocks.inlines)
    case .bulletedList(_, let items):
      return items.flatMap(\.blocks.inlines)
    case .numberedList(_, _, let items):
      return items.flatMap(\.blocks.inlines)
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

extension ListItem {
  init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(blocks: .init(node.children.compactMap(AnyBlock.init(node:))))
  }
}

extension TaskListItem {
  init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(
      isCompleted: node.isTaskListItemChecked,
      blocks: .init(node.children.compactMap(AnyBlock.init(node:)))
    )
  }
}
