import SwiftUI

struct TaskListView: View {
  @Environment(\.listLevel) private var listLevel

  private let isTight: Bool
  private let items: [RawTaskListItem]

  init(isTight: Bool, items: [RawTaskListItem]) {
    self.isTight = isTight
    self.items = items
  }

  var body: some View {
    BlockSequence(self.items) { _, item in
      ApplyBlockStyle(\.listItem, to: TaskListItemView(item: item))
    }
    .labelStyle(.titleAndIcon)
    .environment(\.listLevel, self.listLevel + 1)
    .environment(\.tightSpacingEnabled, self.isTight)
  }
}
