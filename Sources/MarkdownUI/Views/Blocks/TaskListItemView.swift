import SwiftUI

struct TaskListItemView: View {
  private let item: TaskListItem

  init(item: TaskListItem) {
    self.item = item
  }

  var body: some View {
    Label {
      BlockSequence(self.item.blocks)
    } icon: {
      ApplyBlockStyle(\.taskListMarker, configuration: .init(isCompleted: self.item.isCompleted))
        .textStyleFont()
    }
  }
}
