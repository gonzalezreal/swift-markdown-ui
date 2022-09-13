import SwiftUI

internal struct OrderedListView: View {
  @Environment(\.theme.orderedListMarker) private var orderedListMarker
  @Environment(\.listLevel) private var listLevel

  @State private var listMarkerWidth: CGFloat?

  private var children: [Indexed<Int, Block>]
  private var start: Int

  init(children: [Block], start: Int) {
    self.children = children.indexed()
    self.start = start
  }

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        Label {
          BlockView(block.value)
        } icon: {
          ListMarker(
            style: orderedListMarker,
            configuration: .init(listLevel: listLevel, number: block.index + start)
          )
          .columnWidthPreference(0)
          .frame(width: listMarkerWidth, alignment: .trailing)
        }
      }
    }
    .onPreferenceChange(ColumnWidthPreference.self) { columnWidths in
      listMarkerWidth = columnWidths[0]
    }
  }
}
