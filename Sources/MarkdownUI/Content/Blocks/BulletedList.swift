import Foundation

public struct BulletedList: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.bulletedList(tight: self.tight, items: self.items)])
  }

  private let tight: Bool
  private let items: [ListItem]

  init(tight: Bool, items: [ListItem]) {
    // Force loose spacing if any of the items contains more than one paragraph
    let hasItemsWithMultipleParagraphs = items.contains { item in
      item.blocks.filter(\.isParagraph).count > 1
    }

    self.tight = hasItemsWithMultipleParagraphs ? false : tight
    self.items = items
  }

  public init(tight: Bool = true, @ListContentBuilder items: () -> [ListItem]) {
    self.init(tight: tight, items: items())
  }

  public init<S: Sequence>(
    of sequence: S,
    tight: Bool = true,
    @ListContentBuilder items: (S.Element) -> [ListItem]
  ) {
    self.init(tight: tight, items: sequence.flatMap { items($0) })
  }
}
