import SwiftUI

public struct NumberedList<Content: ListContent>: BlockContent {
  @Environment(\.theme.numberedListMarker) private var numberedListMarker
  @Environment(\.listLevel) private var listLevel

  @State private var listMarkerWidth: CGFloat?

  private let tight: Bool
  private let start: Int
  private let content: Content

  private init(tight: Bool, start: Int, content: Content) {
    self.tight = tight
    self.start = start
    self.content = content
  }

  public init(tight: Bool = true, start: Int = 1, @ListContentBuilder content: () -> Content) {
    self.init(tight: tight, start: start, content: content())
  }

  public var body: some View {
    PrimitiveList(
      content: content,
      listMarkerStyle: numberedListMarker,
      listMarkerWidth: listMarkerWidth,
      listStart: start
    )
    .environment(\.listLevel, listLevel + 1)
    .environment(\.tightSpacingEnabled, tight)
    .onPreferenceChange(ColumnWidthPreference.self) { columnWidths in
      listMarkerWidth = columnWidths[0]
    }
  }
}

extension NumberedList where Content == _ListContentSequence<ListItem<_BlockSequence<Block>>> {
  init(tight: Bool, start: Int, items: [ListItem<_BlockSequence<Block>>]) {
    self.init(tight: tight, start: start, content: .init(items: items))
  }
}
