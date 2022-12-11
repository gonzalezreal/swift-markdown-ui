import SwiftUI

public struct TableBorderStyle {
  let border: TableBorder
  let color: Color
  let strokeStyle: StrokeStyle

  public init(_ border: TableBorder = .all, color: Color, strokeStyle: StrokeStyle) {
    self.border = border
    self.color = color
    self.strokeStyle = strokeStyle
  }

  public init(_ border: TableBorder = .all, color: Color, width: CGFloat = 1) {
    self.init(border, color: color, strokeStyle: .init(lineWidth: width))
  }
}
