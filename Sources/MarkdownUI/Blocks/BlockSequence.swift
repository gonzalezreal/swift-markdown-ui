import SwiftUI
import cmark_gfm

public struct _BlockSequence<Element: BlockContent>: BlockContent {
  @Environment(\.multilineTextAlignment) private var textAlignment
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled

  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

  private let blocks: [Numbered<Element>]

  init(blocks: [Element]) {
    self.blocks = blocks.numbered()
  }

  private var spacing: CGFloat {
    tightSpacingEnabled ? 0 : paragraphSpacing
  }

  public var body: some View {
    VStack(alignment: textAlignment.alignment.horizontal, spacing: spacing) {
      ForEach(blocks, id: \.number) { block in
        block.element
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
