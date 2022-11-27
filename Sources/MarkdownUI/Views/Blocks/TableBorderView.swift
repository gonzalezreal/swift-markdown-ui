import SwiftUI

struct TableBorderView: View {
  @Environment(\.theme.tableBorder) private var tableBorder

  private let tableBounds: TableBounds

  init(tableBounds: TableBounds) {
    self.tableBounds = tableBounds
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      let rectangles = self.tableBorder.border.rectangles(self.tableBounds, self.borderWidth)
      ForEach(0..<rectangles.count, id: \.self) {
        let rectangle = rectangles[$0]
        Rectangle()
          .strokeBorder(self.tableBorder.style, style: self.tableBorder.strokeStyle)
          .offset(x: rectangle.minX, y: rectangle.minY)
          .frame(width: rectangle.width, height: rectangle.height)
      }
    }
  }

  private var borderWidth: CGFloat {
    self.tableBorder.strokeStyle.lineWidth
  }
}
