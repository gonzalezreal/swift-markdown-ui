import SwiftUI

internal struct OrderedListView: View {
  @Environment(\.theme.orderedListMarker) private var orderedListMarker
  @Environment(\.listLevel) private var listLevel

  @State private var listMarkerWidth: CGFloat?

  private struct Item: Hashable {
    var number: Int
    var content: Block
  }

  private var items: [Item]

  init(children: [Block], start: Int) {
    items = zip(children.indices, children).map { index, block in
      Item(number: index + start, content: block)
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(items, id: \.self) { item in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarker(style: orderedListMarker) {
            .init(listLevel: listLevel, number: item.number)
          }
          .columnWidthPreference(0)
          .frame(width: listMarkerWidth, alignment: .trailing)
          BlockView(item.content)
        }
      }
    }
    .onPreferenceChange(ColumnWidthPreference.self) { columnWidths in
      listMarkerWidth = columnWidths[0]
    }
  }
}
