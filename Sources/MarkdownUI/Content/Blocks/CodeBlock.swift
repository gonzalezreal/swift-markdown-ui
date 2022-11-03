import Foundation

public struct CodeBlock: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.codeBlock(info: self.language, content: self.content)])
  }

  private let language: String?
  private let content: String

  public init(language: String? = nil, content: String) {
    self.language = language
    self.content = content
  }

  public init(language: String? = nil, content: () -> String) {
    self.init(language: language, content: content())
  }
}
