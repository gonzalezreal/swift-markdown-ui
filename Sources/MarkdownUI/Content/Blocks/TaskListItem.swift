import Foundation

public struct TaskListItem: Hashable {
  let isCompleted: Bool
  let blocks: [Block]

  init(isCompleted: Bool, blocks: [Block]) {
    self.isCompleted = isCompleted
    self.blocks = blocks
  }

  init(_ text: String) {
    self.init(isCompleted: false, blocks: [.paragraph([.text(text)])])
  }

  public init(isCompleted: Bool = false, @MarkdownContentBuilder content: () -> MarkdownContent) {
    self.init(isCompleted: isCompleted, blocks: content().blocks)
  }
}
