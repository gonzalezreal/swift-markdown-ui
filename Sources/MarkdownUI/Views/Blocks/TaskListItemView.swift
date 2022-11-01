import SwiftUI

struct TaskListItemView: View {
  @Environment(\.theme.taskListMarker) private var taskListMarker
  @Environment(\.theme.taskListItem) private var taskListItem

  private let item: TaskListItem

  init(item: TaskListItem) {
    self.item = item
  }

  var body: some View {
    Label {
      BlockSequence(self.item.blocks)
        .environment(
          \.textTransform,
          .init(taskListItem: self.taskListItem, isCompleted: item.isCompleted)
        )
    } icon: {
      self.taskListMarker
        .makeBody(.init(isCompleted: self.item.isCompleted))
    }
  }
}

extension TextTransform {
  fileprivate init?(taskListItem: TaskListItemStyle, isCompleted: Bool) {
    self.init {
      taskListItem.makeBody(.init(text: $0, isCompleted: isCompleted))
    }
  }
}
