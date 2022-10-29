import SwiftUI

struct ListItemSequence: View {
  private struct NumberedListItem: Hashable {
    let number: Int
    let item: ListItem
  }

  private let items: [Identified<Int, NumberedListItem>]
  private let markerStyle: ListMarkerStyle
  private let markerWidth: CGFloat?

  init(
    items: [ListItem],
    start: Int = 1,
    markerStyle: ListMarkerStyle,
    markerWidth: CGFloat? = nil
  ) {
    self.items = zip(start..., items)
      .map { NumberedListItem(number: $0.0, item: $0.1) }
      .identified()
    self.markerStyle = markerStyle
    self.markerWidth = markerWidth
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(items) { item in
        ListItemView(
          item: item.value.item,
          number: item.value.number,
          markerStyle: self.markerStyle,
          markerWidth: self.markerWidth
        )
        .topPadding(enabled: item.id != items.first?.id)
        .bottomPadding(enabled: item.id != items.last?.id)
      }
    }
    .labelStyle(.titleAndIcon)
  }
}
