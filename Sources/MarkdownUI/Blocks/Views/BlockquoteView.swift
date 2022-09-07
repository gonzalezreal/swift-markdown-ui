import SwiftUI

internal struct BlockquoteView: View {
  @Environment(\.theme.blockquote) private var style
  @Environment(\.theme.indentSize) private var indentSize
  @Environment(\.font) private var font
  @Environment(\.multilineTextAlignment) private var textAlignment

  private var blockquote: Blockquote

  init(_ blockquote: Blockquote) {
    self.blockquote = blockquote
  }

  var body: some View {
    BlockGroup(blockquote.children)
      .blockStyle(style: style) { label in
        .init(label: label, font: font, textAlignment: textAlignment, indentSize: indentSize)
      }
  }
}
