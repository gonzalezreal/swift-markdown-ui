import SwiftUI

struct TaskListItemView: View {
  private let item: RawTaskListItem

  init(item: RawTaskListItem) {
    self.item = item
  }

  var body: some View {
    Label {
      BlockSequence(self.item.children)
    } icon: {
      ApplyBlockStyle(\.taskListMarker, configuration: .init(isCompleted: self.item.isCompleted))
        .textStyleFont()
    }
  }
}
