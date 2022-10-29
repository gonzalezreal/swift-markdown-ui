import Foundation

public struct Heading: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.heading(level: self.level, text: self.content.inlines)])
  }

  private let level: Int
  private let content: InlineContent

  private static let levels = 1...6

  public init(level: Int = 1, @InlineContentBuilder content: () -> InlineContent) {
    precondition(Self.levels.contains(level), "Heading level \(level) is out of range.")
    self.level = level
    self.content = content()
  }
}
