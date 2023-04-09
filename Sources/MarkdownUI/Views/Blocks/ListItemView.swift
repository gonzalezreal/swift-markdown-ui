import SwiftUI

struct ListItemView: View {
  @Environment(\.theme.listItem) private var listItem
  @Environment(\.listLevel) private var listLevel

  private let item: RawListItem
  private let number: Int
  private let markerStyle: BlockStyle<ListMarkerConfiguration>
  private let markerWidth: CGFloat?

  init(
    item: RawListItem,
    number: Int,
    markerStyle: BlockStyle<ListMarkerConfiguration>,
    markerWidth: CGFloat?
  ) {
    self.item = item
    self.number = number
    self.markerStyle = markerStyle
    self.markerWidth = markerWidth
  }

  var body: some View {
    self.listItem.makeBody(
      configuration: .init(
        label: .init(self.label),
        content: .init(blocks: item.children)
      )
    )
  }

  private var label: some View {
    Label {
      BlockSequence(self.item.children)
    } icon: {
      self.markerStyle
        .makeBody(configuration: .init(listLevel: self.listLevel, itemNumber: self.number))
        .textStyleFont()
        .readWidth(column: 0)
        .frame(width: self.markerWidth, alignment: .trailing)
    }
  }
}
