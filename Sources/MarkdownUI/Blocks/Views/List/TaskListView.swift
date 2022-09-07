import SwiftUI

internal struct TaskListView: View {
  @Environment(\.theme.taskListMarker) private var taskListMarker
  @Environment(\.theme.taskListItem) private var taskListItem
  @Environment(\.listLevel) private var listLevel

  var children: [Block]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarkerView(
            content: taskListMarker.makeBody(
              .init(listLevel: listLevel, checkbox: block.listItem?.checkbox)
            )
          )
          BlockView(block)
            .environment(
              \.inlineGroupTransform,
              .init(
                taskListItem: taskListItem,
                checkbox: block.listItem?.checkbox
              )
            )
        }
      }
    }
  }
}

extension InlineGroupTransform {
  fileprivate init?(taskListItem: Markdown.TaskListItemStyle, checkbox: Checkbox?) {
    guard let checkbox = checkbox else {
      return nil
    }
    self.init { label in
      taskListItem.makeBody(
        .init(label: label, completed: checkbox == .checked)
      )
    }
  }
}
