import SwiftUI

struct TableBorderView: View {
  @Environment(\.tableBorderStyle) private var tableBorderStyle

  private let tableBounds: TableBounds

  init(tableBounds: TableBounds) {
    self.tableBounds = tableBounds
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      ForEach(0..<self.tableBorderStyle.borders.count, id: \.self) {
        let border = self.tableBorderStyle.borders[$0]
        let rectangles = border.visibleBorders.rectangles(
          self.tableBounds, self.borderWidth
        )
        ForEach(0..<rectangles.count, id: \.self) {
          let rectangle = rectangles[$0]
          Rectangle()
            .strokeBorder(border.color, style: self.tableBorderStyle.strokeStyle)
            .offset(x: rectangle.minX, y: rectangle.minY)
            .frame(width: rectangle.width, height: rectangle.height)
        }
      }
    }
  }

  private var borderWidth: CGFloat {
    self.tableBorderStyle.strokeStyle.lineWidth
  }
}
