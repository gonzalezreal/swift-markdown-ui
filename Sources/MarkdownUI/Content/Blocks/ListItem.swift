import Foundation

/// A Markdown list item.
///
/// You can use list items to compose bulleted and numbered lists.
///
/// ```swift
/// Markdown {
///   NumberedList {
///     ListItem {
///       "Item one"
///       "Additional paragraph"
///     }
///     ListItem {
///       "Item two"
///       BulletedList {
///         "Subitem one"
///         "Subitem two"
///       }
///     }
///   }
/// }
/// ```
///
/// ![](ListItem)
public struct ListItem: Hashable {
  let blocks: [Block]

  init(blocks: [Block]) {
    self.blocks = blocks
  }

  init(_ text: String) {
    self.init(blocks: [.paragraph([.text(text)])])
  }

  public init(@MarkdownContentBuilder content: () -> MarkdownContent) {
    self.init(blocks: content().blocks)
  }
}
