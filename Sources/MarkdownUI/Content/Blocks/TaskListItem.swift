import Foundation

public struct TaskListItem: Hashable {
  let isCompleted: Bool
  let blocks: [AnyBlock]

  public init(isCompleted: Bool, blocks: [AnyBlock]) {
    self.isCompleted = isCompleted
    self.blocks = blocks
  }

  public init(isCompleted: Bool = false, @MarkdownContentBuilder blocks: () -> [AnyBlock]) {
    self.init(isCompleted: isCompleted, blocks: blocks())
  }
}
