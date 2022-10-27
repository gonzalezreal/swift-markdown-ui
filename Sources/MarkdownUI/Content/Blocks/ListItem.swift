import Foundation

public struct ListItem: Hashable {
  let blocks: [AnyBlock]

  public init(blocks: [AnyBlock]) {
    self.blocks = blocks
  }

  public init(@MarkdownContentBuilder blocks: () -> [AnyBlock]) {
    self.blocks = blocks()
  }
}
