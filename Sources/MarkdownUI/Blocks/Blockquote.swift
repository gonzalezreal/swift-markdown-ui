import SwiftUI

public struct Blockquote<Content: BlockContent>: BlockContent {
  @Environment(\.theme.blockquote) private var style

  private let content: Content

  public init(@BlockContentBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    style.makeBody(.init(content: .init(content)))
  }
}

extension Blockquote where Content == _BlockSequence<Block> {
  init(blocks: [Block]) {
    self.content = _BlockSequence(blocks: blocks)
  }
}
