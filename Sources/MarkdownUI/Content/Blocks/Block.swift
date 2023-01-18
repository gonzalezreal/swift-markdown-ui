import Foundation
@_implementationOnly import cmark_gfm

enum Block: Hashable {
  case blockquote([Block])
  case taskList(tight: Bool, items: [TaskListItem])
  case bulletedList(tight: Bool, items: [ListItem])
  case numberedList(tight: Bool, start: Int, items: [ListItem])
  case codeBlock(info: String?, content: String)
  case htmlBlock(String)
  case paragraph([Inline])
  case heading(level: Int, text: [Inline])
  case table(columnAlignments: [TextTableColumnAlignment?], rows: [[[Inline]]])
  case thematicBreak
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
    case CMARK_NODE_CODE_BLOCK:
      self = .codeBlock(info: node.fenceInfo, content: node.literal!)
    case CMARK_NODE_HTML_BLOCK:
      self = .htmlBlock(node.literal!)
    case CMARK_NODE_PARAGRAPH:
      self = .paragraph(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_HEADING:
      self = .heading(level: node.headingLevel, text: node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_TABLE:
      self = .table(
        columnAlignments: node.tableAlignments.map(TextTableColumnAlignment.init),
        rows: node.children.compactMap { rowNode in
          guard rowNode.type == CMARK_NODE_TABLE_ROW else {
            return nil
          }
          return rowNode.children.compactMap { cellNode in
            guard cellNode.type == CMARK_NODE_TABLE_CELL else {
              return nil
            }
            return cellNode.children.compactMap(Inline.init(node:))
          }
        }
      )
    case CMARK_NODE_THEMATIC_BREAK:
      self = .thematicBreak
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
  fileprivate init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(blocks: .init(node.children.compactMap(Block.init(node:))))
  }
}

extension TaskListItem {
  fileprivate init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(
      isCompleted: node.isTaskListItemChecked,
      blocks: .init(node.children.compactMap(Block.init(node:)))
    )
  }
}

extension TextTableColumnAlignment {
  fileprivate init?(_ character: Character) {
    switch character {
    case "l":
      self = .leading
    case "c":
      self = .center
    case "r":
      self = .trailing
    default:
      return nil
    }
  }
}
