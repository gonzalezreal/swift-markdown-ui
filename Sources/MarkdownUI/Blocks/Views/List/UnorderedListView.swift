import SwiftUI

internal struct UnorderedListView: View {
  @Environment(\.theme.unorderedListMarker) private var unorderedListMarker
  @Environment(\.listLevel) private var listLevel

  private var children: [Indexed<Int, Block>]

  init(children: [Block]) {
    self.children = children.indexed()
  }

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(children, id: \.self) { block in
        Label {
          BlockView(block.value)
        } icon: {
          ListMarker(style: unorderedListMarker, configuration: .init(listLevel: listLevel))
        }
      }
    }
  }
}
