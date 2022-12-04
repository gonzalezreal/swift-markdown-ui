import SwiftUI

struct TaskListItemView: View {
  @Environment(\.theme.taskListMarker) private var taskListMarker
  @Environment(\.fontStyle) private var fontStyle

  private let item: TaskListItem

  init(item: TaskListItem) {
    self.item = item
  }

  var body: some View {
    Label {
      BlockSequence(self.item.blocks)
    } icon: {
      self.taskListMarker
        .makeBody(.init(isCompleted: self.item.isCompleted))
        .font(self.fontStyle.resolve())
    }
  }
}
