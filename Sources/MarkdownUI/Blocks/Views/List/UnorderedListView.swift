import SwiftUI

internal struct UnorderedListView: View {
  @Environment(\.theme.unorderedListMarker) private var unorderedListMarker
  @Environment(\.listLevel) private var listLevel

  var children: [Block]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarker(style: unorderedListMarker) {
            .init(listLevel: listLevel)
          }
          BlockView(block)
        }
      }
    }
  }
}
