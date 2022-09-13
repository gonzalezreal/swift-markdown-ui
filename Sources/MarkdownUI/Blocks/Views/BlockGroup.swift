import SwiftUI

struct BlockGroup: View {
  @Environment(\.multilineTextAlignment) private var textAlignment

  private var blocks: [Indexed<Int, Block>]

  init(_ blocks: [Block]) {
    self.blocks = blocks.indexed()
  }

  var body: some View {
    VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(blocks, id: \.self) { block in
        BlockView(block.value)
      }
    }
  }
}
