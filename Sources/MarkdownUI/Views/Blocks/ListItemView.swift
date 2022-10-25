import SwiftUI

struct ListItemView: View {
  @Environment(\.theme.minListMarkerWidth) private var minMarkerWidth
  @Environment(\.listLevel) private var listLevel

  private let item: ListItem
  private let number: Int
  private let markerStyle: ListMarkerStyle
  private let markerWidth: CGFloat?

  init(item: ListItem, number: Int, markerStyle: ListMarkerStyle, markerWidth: CGFloat?) {
    self.item = item
    self.number = number
    self.markerStyle = markerStyle
    self.markerWidth = markerWidth
  }

  var body: some View {
    Label {
      BlockSequence(self.item.blocks)
    } icon: {
      markerStyle
        .makeBody(.init(listLevel: self.listLevel, number: self.number))
        .frame(minWidth: self.minMarkerWidth, alignment: .trailing)
        .readListMarkerWidth()
        .frame(width: markerWidth, alignment: .trailing)
    }
  }
}
