import SwiftUI

struct NumberedListView: View {
  @Environment(\.theme.numberedListMarker) private var numberedListMarker
  @Environment(\.listLevel) private var listLevel

  @State private var markerWidth: CGFloat?

  private let tight: Bool
  private let start: Int
  private let items: [ListItem]

  init(tight: Bool, start: Int, items: [ListItem]) {
    self.tight = tight
    self.start = start
    self.items = items
  }

  var body: some View {
    ListItemSequence(
      items: self.items,
      start: self.start,
      markerStyle: self.numberedListMarker,
      markerWidth: self.markerWidth
    )
    .environment(\.listLevel, self.listLevel + 1)
    .environment(\.tightSpacingEnabled, self.tight)
    .onColumnWidthChange { columnWidths in
      self.markerWidth = columnWidths[0]
    }
  }
}
