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
    VStack(alignment: .leading, spacing: 0) {
      ForEach(items) { item in
        TaskListItemView(item: item.value)
          .topPadding(enabled: item.id != items.first?.id)
          .spacing(enabled: item.id != items.last?.id)
      }
    }
    .labelStyle(.titleAndIcon)
    .environment(\.listLevel, self.listLevel + 1)
    .environment(\.tightSpacingEnabled, self.tight)
  }
}
