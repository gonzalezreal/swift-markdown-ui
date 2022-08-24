import SwiftUI

internal struct BlockView: View {
  @Environment(\.markdownSpacing) private var spacing
  @Environment(\.markdownTightSpacingEnabled) private var tightSpacingEnabled

  private var block: Block

  init(_ block: Block) {
    self.block = block
  }

  @ViewBuilder private var content: some View {
    switch block.content {
    case .paragraph(let inlines):
      InlineGroup(inlines)
    }
  }

  var body: some View {
    content
      .padding(.bottom, block.hasSuccessor && !tightSpacingEnabled ? spacing : 0)
  }
}