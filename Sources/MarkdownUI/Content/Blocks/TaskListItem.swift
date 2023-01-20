import Foundation

/// A Markdown task list item.
///
/// You can use task list items to compose task lists.
///
/// ```swift
/// Markdown {
///   Paragraph {
///     "Things to do:"
///   }
///   TaskList {
///     TaskListItem(isCompleted: true) {
///       Paragraph {
///         Strikethrough("A finished task")
///       }
///     }
///     TaskListItem {
///       "An unfinished task"
///     }
///     "Another unfinished task"
///   }
/// }
/// ```
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
