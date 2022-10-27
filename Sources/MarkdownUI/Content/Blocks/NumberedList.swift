import Foundation

public struct NumberedList: MarkdownContentProtocol {
  public var markdownContent: MarkdownContent {
    .init(blocks: [.numberedList(tight: self.tight, start: self.start, items: self.items)])
  }

  private let tight: Bool
  private let start: Int
  private let items: [ListItem]

  init(tight: Bool, start: Int, items: [ListItem]) {
    // Force loose spacing if any of the items contains more than one paragraph
    let hasItemsWithMultipleParagraphs = items.contains { item in
      item.blocks.filter(\.isParagraph).count > 1
    }
    self.tight = hasItemsWithMultipleParagraphs ? false : tight
    self.start = start
    self.items = items
  }

  public init(tight: Bool = true, start: Int = 1, @ListContentBuilder items: () -> [ListItem]) {
    self.init(tight: tight, start: start, items: items())
  }

  public init<S: Sequence>(
    of sequence: S,
    tight: Bool = true,
    start: Int = 1,
    @ListContentBuilder items: (S.Element) -> [ListItem]
  ) {
    self.init(tight: tight, start: start, items: sequence.flatMap { items($0) })
  }
}
