import SwiftUI

public struct TableBorderStyle {
  let border: TableBorder
  let style: AnyShapeStyle
  let strokeStyle: StrokeStyle

  public init<S: ShapeStyle>(_ border: TableBorder = .all, style: S, strokeStyle: StrokeStyle) {
    self.border = border
    self.style = .init(style)
    self.strokeStyle = strokeStyle
  }

  public init<S: ShapeStyle>(_ border: TableBorder = .all, style: S, width: CGFloat = 1) {
    self.init(border, style: style, strokeStyle: .init(lineWidth: width))
  }
}

extension TableBorderStyle {
  public static var `default`: TableBorderStyle {
    .init(style: Color.secondary)
  }
}
