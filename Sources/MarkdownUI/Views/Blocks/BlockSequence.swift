import SwiftUI

struct BlockSequence: View {
  @Environment(\.multilineTextAlignment) private var textAlignment

  private let blocks: [Identified<Int, Block>]

  init(_ blocks: [Block]) {
    self.blocks = blocks.identified()
  }

  var body: some View {
    VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(blocks) { block in
        block.value
          .spacingBefore(enabled: block.id != blocks.first?.id)
          .spacing(enabled: block.id != blocks.last?.id)
      }
    }
  }
}
