import Foundation

public struct Link: InlineContentProtocol {
  public var inlineContent: InlineContent {
    .init(inlines: [.link(destination: self.destination, children: self.content.inlines)])
  }

  private let destination: String
  private let content: InlineContent

  init(destination: String, content: InlineContent) {
    self.destination = destination
    self.content = content
  }

  public init(destination: URL) {
    self.init(
      destination: destination.absoluteString,
      content: .init(inlines: [.text(destination.absoluteString)])
    )
  }

  public init(_ text: String, destination: URL) {
    self.init(destination: destination.absoluteString, content: .init(inlines: [.text(text)]))
  }

  public init(destination: URL, @InlineContentBuilder content: () -> InlineContent) {
    self.init(destination: destination.absoluteString, content: content())
  }
}
