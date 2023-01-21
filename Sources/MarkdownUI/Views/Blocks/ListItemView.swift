import SwiftUI

struct ListItemView: View {
  @Environment(\.listLevel) private var listLevel

  private let item: ListItem
  private let number: Int
  private let markerStyle: BlockStyle<ListMarkerConfiguration>
  private let markerWidth: CGFloat?

  init(
    item: ListItem,
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
    Label {
      BlockSequence(self.item.blocks)
    } icon: {
      self.markerStyle
        .makeBody(configuration: .init(listLevel: self.listLevel, itemNumber: self.number))
        .textStyleFont()
        .readWidth(column: 0)
        .frame(width: self.markerWidth, alignment: .trailing)
    }
  }
}
