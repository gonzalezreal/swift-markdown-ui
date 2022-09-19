import SwiftUI

public struct Blockquote<Content: BlockContent>: BlockContent {
  @Environment(\.theme.blockquote) private var style
  @Environment(\.font) private var font
  @Environment(\.multilineTextAlignment) private var textAlignment

  private let content: Content

  public init(@BlockContentBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    style.makeBody(
      .init(
        content: .init(content),
        font: font,
        textAlignment: textAlignment
      )
    )
  }
}

extension Blockquote where Content == _BlockSequence<Block> {
  init(blocks: [Block]) {
    self.content = _BlockSequence(blocks: blocks)
  }
}
