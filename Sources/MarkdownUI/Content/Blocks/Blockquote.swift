import Foundation

public struct Blockquote: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.blockquote(content.blocks)])
  }

  private let content: MarkdownContent

  public init(@MarkdownContentBuilder content: () -> MarkdownContent) {
    self.content = content()
  }
}
