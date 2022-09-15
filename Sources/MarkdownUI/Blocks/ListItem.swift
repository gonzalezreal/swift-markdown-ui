import SwiftUI
import cmark_gfm

public enum Checkbox {
  case checked
  case unchecked
}

public struct ListItem<Content: BlockContent>: ListContent {
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

  public func makeBody(configuration: Configuration) -> some View {
    Label {
      content
        .environment(
          \.textTransform,
          .init(
            taskListItem: configuration.taskListItemStyle,
            checkbox: checkbox
          )
        )
    } icon: {
      configuration.listMarkerStyle.makeBody(
        .init(
          listLevel: configuration.listLevel,
          number: configuration.listStart,
          checkbox: checkbox
        )
      )
      .frame(minWidth: configuration.minListMarkerWidth, alignment: .trailing)
      .columnWidthPreference(0)
      .frame(width: configuration.listMarkerWidth, alignment: .trailing)
    }
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

extension TextTransform {
  fileprivate init?(taskListItem: TaskListItemStyle, checkbox: Checkbox?) {
    guard let checkbox = checkbox else {
      return nil
    }
    self.init { label in
      taskListItem.makeBody(
        .init(text: label, completed: checkbox == .checked)
      )
    }
  }
}
