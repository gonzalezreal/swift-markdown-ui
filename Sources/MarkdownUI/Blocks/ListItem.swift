import SwiftUI
import cmark_gfm

public enum Checkbox {
  case checked
  case unchecked
}

public struct ListItem<Content: BlockContent>: ListContent {
  public let count = 1

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

  public func makeBody(number: Int, configuration: Configuration) -> some View {
    PrimitiveListItem(
      checkbox: checkbox, content: content, number: number, configuration: configuration
    )
  }
}

extension ListItem where Content == _BlockSequence<Block> {
  init?(node: CommonMarkNode) {
    guard node.type == CMARK_NODE_ITEM else {
      return nil
    }
    self.init(
      checkbox: node.isTaskListItem ? (node.isTaskListItemChecked ? .checked : .unchecked) : nil,
      content: .init(blocks: node.children.compactMap(Block.init(node:)))
    )
  }
}
