import SwiftUI

struct TaskListView: View {
  @Environment(\.listLevel) private var listLevel

  private let tight: Bool
  private let items: [Identified<Int, TaskListItem>]

  init(tight: Bool, items: [TaskListItem]) {
    self.tight = tight
    self.items = items.identified()
  }

  var body: some View {
    Spaced(self.items) { item in
      ApplyBlockStyle(\.listItem, to: TaskListItemView(item: item.value))
    }
    .labelStyle(.titleAndIcon)
    .environment(\.listLevel, self.listLevel + 1)
    .environment(\.tightSpacingEnabled, self.tight)
  }
}
