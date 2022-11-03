import SwiftUI

struct ListItemSequence: View {
  private struct NumberedListItem: Hashable {
    let number: Int
    let item: ListItem
  }

  private let items: [Identified<Int, NumberedListItem>]
  private let markerStyle: ListMarkerStyle<ListItemConfiguration>
  private let markerWidth: CGFloat?

  init(
    items: [ListItem],
    start: Int = 1,
    markerStyle: ListMarkerStyle<ListItemConfiguration>,
    markerWidth: CGFloat? = nil
  ) {
    self.items = zip(start..., items)
      .map { NumberedListItem(number: $0.0, item: $0.1) }
      .identified()
    self.markerStyle = markerStyle
    self.markerWidth = markerWidth
  }

  var body: some View {
    BlockSequence(self.items) { item in
      ApplyBlockStyle(
        \.listItem,
        to: ListItemView(
          item: item.value.item,
          number: item.value.number,
          markerStyle: self.markerStyle,
          markerWidth: self.markerWidth
        )
      )
    }
    .labelStyle(.titleAndIcon)
  }
}
