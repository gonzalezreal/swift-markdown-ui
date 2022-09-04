import SwiftUI

internal struct BlockView: View {
  @Environment(\.hasSuccessor) private var parentHasSuccessor

  private var block: Block

  init(_ block: Block) {
    self.block = block
  }

  @ViewBuilder private var content: some View {
    switch block.content {
    case .list(let list):
      ListView(list)
    case .listItem(let listItem):
      BlockGroup(listItem.children)
    case .paragraph(let inlines):
      ParagraphView(inlines)
    }
  }

  var body: some View {
    content
      .environment(\.hasSuccessor, parentHasSuccessor || block.hasSuccessor)
  }
}
