import SwiftUI

public struct Blockquote<Content: BlockContent>: BlockContent {
  private struct _View: View {
    @Environment(\.theme.blockquote) private var style

    let content: Content

    var body: some View {
      style.makeBody(.init(content: .init(content.render())))
    }
  }

  private let content: Content

  public init(@BlockContentBuilder content: () -> Content) {
    self.content = content()
  }

  public func render() -> some View {
    _View(content: content)
  }
}

extension Blockquote where Content == _ContentSequence<Block> {
  init(blocks: [Block]) {
    self.content = _ContentSequence(blocks)
  }
}
