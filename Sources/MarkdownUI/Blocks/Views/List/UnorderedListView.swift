import SwiftUI

internal struct UnorderedListView: View {
  @Environment(\.theme.unorderedListMarker) private var unorderedListMarker
  @Environment(\.listLevel) private var listLevel

  var children: [Block]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarkerView(
            content: unorderedListMarker.makeBody(.init(listLevel: listLevel))
          )
          BlockView(block)
        }
      }
    }
  }
}
