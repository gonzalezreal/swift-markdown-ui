import SwiftUI

struct ListItemView: View {
  @Environment(\.listLevel) private var listLevel
  @Environment(\.fontStyle) private var fontStyle

  private let item: ListItem
  private let number: Int
  private let markerStyle: ListMarkerStyle<ListItemConfiguration>
  private let markerWidth: CGFloat?

  init(
    item: ListItem,
    number: Int,
    markerStyle: ListMarkerStyle<ListItemConfiguration>,
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
        .makeBody(.init(listLevel: self.listLevel, itemNumber: self.number))
        .font(self.fontStyle.resolve())
        .readWidth(column: 0)
        .frame(width: self.markerWidth, alignment: .trailing)
    }
  }
}
