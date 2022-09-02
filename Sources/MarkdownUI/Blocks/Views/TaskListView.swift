import SwiftUI

internal struct TaskListView: View {
  @Environment(\.markdownIndentSize) private var indentSize
  @Environment(\.taskListMarkerStyle) private var taskListMarkerStyle
  @Environment(\.taskListItemStyle) private var taskListItemStyle

  var children: [Block]

  var body: some View {
    VStack(alignment: .listMarkerAlignment) {
      ForEach(children, id: \.self) { block in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarkerView(
            content: taskListMarkerStyle.makeBody(
              .init(checkbox: block.listItem?.checkbox)
            ),
            minWidth: indentSize
          )
          BlockView(block)
            .environment(
              \.inlineGroupStyle,
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

extension InlineGroupStyle {
  fileprivate init?(taskListItemStyle: TaskListItemStyle, checkbox: Checkbox?) {
    guard let checkbox = checkbox else {
      return nil
    }
    self.init { configuration in
      taskListItemStyle.makeBody(
        .init(label: configuration.label, completed: checkbox == .checked)
      )
    }
  }
}
