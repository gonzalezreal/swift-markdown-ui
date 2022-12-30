import SwiftUI

struct ListItemSequence: View {
  private let items: [ListItem]
  private let start: Int
  private let markerStyle: BlockStyle<ListItemConfiguration>
  private let markerWidth: CGFloat?

  init(
    items: [ListItem],
    start: Int = 1,
    markerStyle: BlockStyle<ListItemConfiguration>,
    markerWidth: CGFloat? = nil
  ) {
    self.items = items
    self.start = start
    self.markerStyle = markerStyle
    self.markerWidth = markerWidth
  }

  var body: some View {
    BlockSequence(self.items) { index, item in
      ApplyBlockStyle(
        \.listItem,
        to: ListItemView(
          item: item,
          number: self.start + index,
          markerStyle: self.markerStyle,
          markerWidth: self.markerWidth
        )
      )
    }
    .labelStyle(.titleAndIcon)
  }
}
