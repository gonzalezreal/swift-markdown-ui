import SwiftUI
import cmark_gfm

public struct _BlockSequence<Element: BlockContent>: BlockContent {
  @Environment(\.multilineTextAlignment) private var textAlignment

  private let blocks: [Numbered<Element>]

  init(blocks: [Element]) {
    self.blocks = blocks.numbered()
  }

  public var body: some View {
    VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(blocks, id: \.number) { block in
        block.element
          .spacing(enabled: block.number < blocks.last!.number)
      }
    }
  }
}

extension _BlockSequence where Element == Block {
  init(markdown: String) {
    let node = CommonMarkNode(markdown: markdown, extensions: .all, options: CMARK_OPT_DEFAULT)
    let blocks = node?.children.compactMap(Block.init(node:)) ?? []

    self.init(blocks: blocks)
  }
}
