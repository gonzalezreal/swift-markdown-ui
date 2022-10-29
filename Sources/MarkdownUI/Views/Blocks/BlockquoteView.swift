import SwiftUI

struct BlockquoteView: View {
  @Environment(\.theme.blockquote) private var style

  private let blocks: [Block]

  init(_ blocks: [Block]) {
    self.blocks = blocks
  }

  var body: some View {
    self.style.makeBody(.init(content: .init(BlockSequence(self.blocks))))
  }
}
