import SwiftUI

struct TaskListView: View {
  @Environment(\.listLevel) private var listLevel

  private let tight: Bool
  private let items: [TaskListItem]

  init(tight: Bool, items: [TaskListItem]) {
    self.tight = tight
    self.items = items
  }

  var body: some View {
    BlockSequence(self.items) { _, item in
      ApplyBlockStyle(\.listItem, to: TaskListItemView(item: item))
    }
    .labelStyle(.titleAndIcon)
    .environment(\.listLevel, self.listLevel + 1)
    .environment(\.tightSpacingEnabled, self.tight)
  }
}
