import SwiftUI

internal struct TaskListView: View {
  @Environment(\.theme.indentSize) private var indentSize
  @Environment(\.taskListMarkerStyle) private var taskListMarkerStyle
  @Environment(\.taskListItemStyle) private var taskListItemStyle
  @Environment(\.listLevel) private var listLevel

  var children: [Block]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarkerView(
            content: taskListMarkerStyle.makeBody(
              .init(listLevel: listLevel, checkbox: block.listItem?.checkbox)
            ),
            minWidth: indentSize
          )
          BlockView(block)
            .environment(
              \.inlineGroupTransform,
              .init(
                taskListItemStyle: taskListItemStyle,
                checkbox: block.listItem?.checkbox
              )
            )
        }
      }
    }
  }
}

extension InlineGroupTransform {
  fileprivate init?(taskListItemStyle: TaskListItemStyle, checkbox: Checkbox?) {
    guard let checkbox = checkbox else {
      return nil
    }
    self.init { label in
      taskListItemStyle.makeBody(
        .init(label: label, completed: checkbox == .checked)
      )
    }
  }
}
