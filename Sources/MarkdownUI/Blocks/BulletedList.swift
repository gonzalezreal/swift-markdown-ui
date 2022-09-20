import SwiftUI

public struct BulletedList<Content: ListContent>: BlockContent {
  @Environment(\.theme.bulletedListMarker) private var bulletedListMarker
  @Environment(\.listLevel) private var listLevel

  private let tight: Bool
  private let content: Content

  private init(tight: Bool, content: Content) {
    self.tight = tight
    self.content = content
  }

  public init(tight: Bool = true, @ListContentBuilder content: () -> Content) {
    self.init(tight: tight, content: content())
  }

  public var body: some View {
    PrimitiveList(
      content: content,
      listMarkerStyle: bulletedListMarker
    )
    .environment(\.listLevel, listLevel + 1)
    .environment(\.tightSpacingEnabled, tight)
  }
}

extension BulletedList where Content == _ListContentSequence<ListItem<_BlockSequence<Block>>> {
  init(tight: Bool, items: [ListItem<_BlockSequence<Block>>]) {
    self.init(tight: tight, content: .init(items: items))
  }
}
