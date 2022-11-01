import SwiftUI

struct BlockquoteView: View {
  @Environment(\.theme.blockquote) private var blockquote

  private let blocks: [Block]

  init(_ blocks: [Block]) {
    self.blocks = blocks
  }

  var body: some View {
    self.blockquote.makeBody(.init(BlockSequence(self.blocks)))
  }
}
