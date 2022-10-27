import Foundation

public struct Emphasis: InlineContentProtocol {
  public var inlineContent: InlineContent {
    .init(inlines: [.emphasis(self.content.inlines)])
  }

  private let content: InlineContent

  init(content: InlineContent) {
    self.content = content
  }

  public init(_ text: String) {
    self.init(content: .init(inlines: [.text(text)]))
  }

  public init(@InlineContentBuilder content: () -> InlineContent) {
    self.init(content: content())
  }
}
