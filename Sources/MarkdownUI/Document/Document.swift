import Foundation

public struct Document: Hashable {
  public var blocks: [AnyBlock]

  public init(markdown: String) {
    self.init(blocks: .init(markdown: markdown))
  }

  public init(markdown: Data) {
    self.init(markdown: String(decoding: markdown, as: UTF8.self))
  }

  public init(contentsOf url: URL) throws {
    try self.init(markdown: Data(contentsOf: url))
  }

  public init(@BlockContentBuilder blocks: () -> [AnyBlock]) {
    self.init(blocks: blocks())
  }

  init(blocks: [AnyBlock]) {
    self.blocks = blocks
  }
}
