import Foundation

public struct ThematicBreak: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.thematicBreak])
  }

  public init() {}
}
