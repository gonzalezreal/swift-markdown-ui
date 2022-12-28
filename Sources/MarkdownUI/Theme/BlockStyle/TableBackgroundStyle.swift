import SwiftUI

public struct TableBackgroundStyle {
  let background: (_ row: Int, _ column: Int) -> AnyShapeStyle

  public init<S: ShapeStyle>(background: @escaping (_ row: Int, _ column: Int) -> S) {
    self.background = { row, column in
      AnyShapeStyle(background(row, column))
    }
  }
}

extension TableBackgroundStyle {
  public static var clear: Self {
    TableBackgroundStyle { _, _ in Color.clear }
  }

  public static func alternatingRows<S: ShapeStyle>(_ odd: S, _ even: S, header: S? = nil) -> Self {
    TableBackgroundStyle { row, _ in
      guard row > 0 else {
        return header ?? odd
      }

      return row.isMultiple(of: 2) ? even : odd
    }
  }
}
