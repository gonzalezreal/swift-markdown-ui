import SwiftUI

public struct TaskList<Content: ListContent>: BlockContent {
  @Environment(\.theme.taskListMarker) private var taskListMarker
  @Environment(\.theme.taskListItem) private var taskListItem
  @Environment(\.listLevel) private var listLevel

  private let tight: Bool
  private let content: Content

  private init(tight: Bool, content: Content) {
    self.tight = tight
    self.content = content
  }

  public init(tight: Bool = true, @ListContentBuilder content: () -> Content) {
    self.init(tight: tight, content: content())
  }

  public var body: some View {
    PrimitiveList(
      content: content,
      listMarkerStyle: taskListMarker,
      taskListItemStyle: taskListItem
    )
    .environment(\.listLevel, listLevel + 1)
    .environment(\.tightSpacingEnabled, tight)
  }
}

extension TaskList where Content == _ListContentSequence<ListItem<_BlockSequence<Block>>> {
  init(tight: Bool, items: [ListItem<_BlockSequence<Block>>]) {
    self.init(tight: tight, content: .init(items: items))
  }
}
