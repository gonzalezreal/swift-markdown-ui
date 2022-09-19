import SwiftUI

public struct TaskList<Content: ListContent>: BlockContent {
  @Environment(\.theme.taskListMarker) private var taskListMarker
  @Environment(\.theme.taskListItem) private var taskListItem
  @Environment(\.theme.minListMarkerWidth) private var minListMarkerWidth
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
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
    content.makeBody(
      configuration: .init(
        listMarkerStyle: taskListMarker,
        taskListItemStyle: taskListItem,
        spacing: tight ? 0 : paragraphSpacing,
        minListMarkerWidth: minListMarkerWidth,
        listLevel: listLevel
      )
    )
    .labelStyle(.titleAndIcon)
    .environment(\.listLevel, listLevel + 1)
    .environment(\.tightSpacingEnabled, tight)
  }
}

extension TaskList where Content == _ListContentSequence<ListItem<_BlockSequence<Block>>> {
  init(tight: Bool, items: [ListItem<_BlockSequence<Block>>]) {
    self.init(tight: tight, content: .init(items: items))
  }
}
