import Foundation

public struct Image: InlineContentProtocol {
  public var inlineContent: InlineContent {
    .init(inlines: [.image(source: self.source, children: self.content.inlines)])
  }

  private let source: String
  private let content: InlineContent

  init(source: String, content: InlineContent) {
    self.source = source
    self.content = content
  }

  public init(source: URL) {
    self.init(source: source.absoluteString, content: .empty)
  }

  public init(_ text: String, source: URL) {
    self.init(source: source.absoluteString, content: .init(inlines: [.text(text)]))
  }
}
