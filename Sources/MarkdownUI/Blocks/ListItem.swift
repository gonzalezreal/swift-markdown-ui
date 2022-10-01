import SwiftUI
import cmark_gfm

public enum Checkbox {
  case checked
  case unchecked
}

public struct ListItem<Content: BlockContent>: ListContent {
  public var itemCount: Int { 1 }

  private let checkbox: Checkbox?
  private let content: Content

  private init(checkbox: Checkbox?, content: Content) {
    self.checkbox = checkbox
    self.content = content
  }

  public init(@BlockContentBuilder content: () -> Content) {
    self.init(checkbox: nil, content: content())
  }

  public init(checkbox: Checkbox, @BlockContentBuilder content: () -> Content) {
    self.init(checkbox: checkbox, content: content())
  }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    PrimitiveListItem(
      checkbox: checkbox, content: content, number: itemNumber, configuration: configuration
    )
  }
}

extension ListItem where Content == _ContentSequence<Block> {
  init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(
      checkbox: node.isTaskListItem ? (node.isTaskListItemChecked ? .checked : .unchecked) : nil,
      content: .init(node.children.compactMap(Block.init(node:)))
    )
  }
}
