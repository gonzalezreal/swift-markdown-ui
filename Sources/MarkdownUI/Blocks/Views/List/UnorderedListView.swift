import SwiftUI

internal struct UnorderedListView: View {
  @Environment(\.markdownIndentSize) private var indentSize
  @Environment(\.unorderedListMarkerStyle) private var unorderedListMarkerStyle
  @Environment(\.listLevel) private var listLevel

  var children: [Block]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ListMarkerView(
            content: unorderedListMarkerStyle.makeBody(.init(listLevel: listLevel)),
            minWidth: indentSize
          )
          BlockView(block)
        }
      }
    }
  }
}
