import Foundation
import cmark_gfm

internal struct Block: Hashable {
  enum Content: Hashable {
    case list(List)
    case listItem(ListItem)
    case paragraph([Inline])
  }

  var id: Int
  var hasSuccessor: Bool
  var content: Content
}

extension Block {
  var listItem: ListItem? {
    guard case .listItem(let listItem) = content else {
      return nil
    }
    return listItem
  }
}

extension Block {
  init?(commonMarkNode: CommonMarkNode, makeId: () -> Int) {
    let content: Content

    switch commonMarkNode.type {
    case CMARK_NODE_LIST:
      content = .list(
        .init(
          children: commonMarkNode.children.compactMap { childNode in
            Block(commonMarkNode: childNode, makeId: makeId)
          },
          isTight: commonMarkNode.listTight,
          listType: .init(commonMarkNode)
        )
      )
    case CMARK_NODE_ITEM:
      content = .listItem(
        .init(
          checkbox: .init(commonMarkNode),
          children: commonMarkNode.children.compactMap { childNode in
            Block(commonMarkNode: childNode, makeId: makeId)
          }
        )
      )
    case CMARK_NODE_PARAGRAPH:
      content = .paragraph(commonMarkNode.children.compactMap(Inline.init(commonMarkNode:)))
    default:
      assertionFailure("Unknown block type '\(commonMarkNode.typeString)'")
      return nil
    }

    self.init(id: makeId(), hasSuccessor: commonMarkNode.hasSuccessor, content: content)
  }
}

extension ListType {
  fileprivate init(_ commonMarkNode: CommonMarkNode) {
    if commonMarkNode.listType == CMARK_ORDERED_LIST {
      self = .ordered(start: commonMarkNode.listStart)
    } else {
      self = .unordered
    }
  }
}

extension Checkbox {
  fileprivate init?(_ commonMarkNode: CommonMarkNode) {
    guard commonMarkNode.isTaskListItem else { return nil }
    self = commonMarkNode.isTaskListItemChecked ? .checked : .unchecked
  }
}
