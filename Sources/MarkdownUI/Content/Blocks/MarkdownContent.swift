import Foundation

public protocol MarkdownContentProtocol {
  var markdownContent: MarkdownContent { get }
}

public struct MarkdownContent: Equatable, MarkdownContentProtocol {
  public var markdownContent: MarkdownContent { self }
  let blocks: [AnyBlock]

  init(blocks: [AnyBlock] = []) {
    self.blocks = blocks
  }

  init(_ components: [MarkdownContentProtocol]) {
    self.init(blocks: components.map(\.markdownContent).flatMap(\.blocks))
  }

  public init(_ markdown: String) {
    self.init(blocks: .init(markdown: markdown))
  }

  public init(_ markdown: Data) {
    self.init(String(decoding: markdown, as: UTF8.self))
  }

  public init(contentsOf url: URL) throws {
    try self.init(Data(contentsOf: url))
  }

  public init(@MarkdownContentBuilder content: () -> MarkdownContent) {
    self.init(blocks: content().blocks)
  }
}
