import Foundation
import cmark_gfm

internal struct Block: Hashable {
  enum Content: Hashable {
    case orderedList(OrderedList)
    case unorderedList(UnorderedList)
    case listItem(ListItem)
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
    case CMARK_NODE_LIST where commonMarkNode.listType == CMARK_ORDERED_LIST:
      content = .orderedList(
        .init(
          children: commonMarkNode.children.compactMap { childNode in
            Block(commonMarkNode: childNode, makeId: makeId)
          },
          tightSpacingEnabled: commonMarkNode.listTight,
          start: commonMarkNode.listStart
        )
      )
    case CMARK_NODE_LIST:
      content = .unorderedList(
        .init(
          children: commonMarkNode.children.compactMap { childNode in
            Block(commonMarkNode: childNode, makeId: makeId)
          },
          tightSpacingEnabled: commonMarkNode.listTight
        )
      )
    case CMARK_NODE_ITEM:
      content = .listItem(
        .init(
          checkbox: commonMarkNode.listItemCheckbox,
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

extension CommonMarkNode {
  fileprivate var listItemCheckbox: Checkbox? {
    guard isTaskListItem else { return nil }
    return isTaskListItemChecked ? .checked : .unchecked
  }
}
