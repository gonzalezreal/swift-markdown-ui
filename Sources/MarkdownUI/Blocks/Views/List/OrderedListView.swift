import SwiftUI

internal struct OrderedListView: View {
  @Environment(\.theme.indentSize) private var indentSize
  @Environment(\.orderedListMarkerStyle) private var orderedListMarkerStyle
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
          ListMarkerView(
            content: orderedListMarkerStyle.makeBody(
              .init(listLevel: listLevel, number: item.number)
            ),
            minWidth: indentSize
          )
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
