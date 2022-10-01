import SwiftUI

public struct BulletedList<Content: ListContent>: BlockContent {
  private struct _View: View {
    @Environment(\.theme.bulletedListMarker) private var bulletedListMarker
    @Environment(\.listLevel) private var listLevel

    let tight: Bool
    let content: Content

    var body: some View {
      PrimitiveList(
        content: content,
        listMarkerStyle: bulletedListMarker
      )
      .environment(\.listLevel, listLevel + 1)
      .environment(\.tightSpacingEnabled, tight)
    }
  }

  private let tight: Bool
  private let content: Content

  private init(tight: Bool, content: Content) {
    self.tight = tight
    self.content = content
  }

  public init(tight: Bool = true, @ListContentBuilder content: () -> Content) {
    self.init(tight: tight, content: content())
  }

  public func render() -> some View {
    _View(tight: tight, content: content)
  }
}

extension BulletedList {
  public init<Data: Sequence, ItemContent: ListContent>(
    data: Data,
    tight: Bool = true,
    @ListContentBuilder itemContent: (Data.Element) -> ItemContent
  ) where Content == _ContentSequence<ItemContent> {
    self.init(tight: tight, content: .init(data.map(itemContent)))
  }
}

extension BulletedList where Content == _ContentSequence<ListItem<_ContentSequence<Block>>> {
  init(tight: Bool, items: [ListItem<_ContentSequence<Block>>]) {
    self.init(tight: tight, content: .init(items))
  }
}
