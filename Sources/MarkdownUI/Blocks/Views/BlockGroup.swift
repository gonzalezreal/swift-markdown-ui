import SwiftUI

struct BlockGroup: View {
  @Environment(\.multilineTextAlignment) private var textAlignment

  private var blocks: [Block]

  init(_ blocks: [Block]) {
    self.blocks = blocks
  }

  var body: some View {
    VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(blocks, id: \.self, content: BlockView.init)
    }
  }
}
