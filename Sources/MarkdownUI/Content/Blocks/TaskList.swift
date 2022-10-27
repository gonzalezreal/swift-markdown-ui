import Foundation

public struct TaskList: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.taskList(tight: self.tight, items: self.items)])
  }

  private let tight: Bool
  private let items: [TaskListItem]

  init(tight: Bool, items: [TaskListItem]) {
    // Force loose spacing if any of the items contains more than one paragraph
    let hasItemsWithMultipleParagraphs = items.contains { item in
      item.blocks.filter(\.isParagraph).count > 1
    }

    self.tight = hasItemsWithMultipleParagraphs ? false : tight
    self.items = items
  }

  public init(tight: Bool = true, @TaskListContentBuilder items: () -> [TaskListItem]) {
    self.init(tight: tight, items: items())
  }

  public init<S: Sequence>(
    of sequence: S,
    tight: Bool = true,
    @TaskListContentBuilder items: (S.Element) -> [TaskListItem]
  ) {
    self.init(tight: tight, items: sequence.flatMap { items($0) })
  }
}
