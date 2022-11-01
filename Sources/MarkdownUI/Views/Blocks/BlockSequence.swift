import SwiftUI

struct BlockSequence: View {
  private let blocks: [Identified<Int, Block>]

  init(_ blocks: [Block]) {
    self.blocks = blocks.identified()
  }

  var body: some View {
    Spaced(self.blocks) { block in
      block.value
    }
  }
}
