import Foundation

public struct ListItem: Hashable {
  let blocks: [AnyBlock]

  public init(blocks: [AnyBlock]) {
    self.blocks = blocks
  }

  public init(@BlockContentBuilder blocks: () -> [AnyBlock]) {
    self.blocks = blocks()
  }
}
