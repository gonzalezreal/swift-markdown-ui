import Foundation

public struct Paragraph: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.paragraph(self.content.inlines)])
  }

  private let content: InlineContent

  public init(@InlineContentBuilder content: () -> InlineContent) {
    self.content = content()
  }
}
