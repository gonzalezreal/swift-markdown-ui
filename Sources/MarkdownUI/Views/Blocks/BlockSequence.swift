import SwiftUI

struct BlockSequence: View {
  @Environment(\.multilineTextAlignment) private var textAlignment

  private let blocks: [Identified<Int, AnyBlock>]

  init(_ blocks: [AnyBlock]) {
    self.blocks = blocks.identified()
  }

  var body: some View {
    VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(blocks) { block in
        block.value
          .blockSpacing(enabled: block.id != blocks.last?.id)
      }
    }
  }
}