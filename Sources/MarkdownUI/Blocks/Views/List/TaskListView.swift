import SwiftUI

internal struct TaskListView: View {
  @Environment(\.theme.taskListMarker) private var taskListMarker
  @Environment(\.theme.taskListItem) private var taskListItem
  @Environment(\.listLevel) private var listLevel

  private var children: [Indexed<Int, Block>]

  init(children: [Block]) {
    self.children = children.indexed()
  }

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        Label {
          BlockView(block.value)
            .environment(
              \.inlineGroupTransform,
              .init(
                taskListItem: taskListItem,
                checkbox: block.value.listItem?.checkbox
              )
            )
        } icon: {
          ListMarker(
            style: taskListMarker,
            configuration: .init(listLevel: listLevel, checkbox: block.value.listItem?.checkbox)
          )
        }
      }
    }
  }
}

extension InlineGroupTransform {
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
