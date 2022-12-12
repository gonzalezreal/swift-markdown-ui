import SwiftUI

public struct TableCellBackgroundStyle {
  public struct Configuration {
    public let row: Int
    public let column: Int
  }

  let makeShapeStyle: (Configuration) -> AnyShapeStyle

  public init<S: ShapeStyle>(makeShapeStyle: @escaping (Configuration) -> S) {
    self.makeShapeStyle = { AnyShapeStyle(makeShapeStyle($0)) }
  }
}

extension TableCellBackgroundStyle {
  public static var clear: TableCellBackgroundStyle {
    TableCellBackgroundStyle { _ in
      Color.clear
    }
  }

  public static func alternatingRows<S: ShapeStyle>(
    _ odd: S, _ even: S, header: S? = nil
  ) -> TableCellBackgroundStyle {
    TableCellBackgroundStyle { configuration in
      guard configuration.row > 0 else {
        return header ?? odd
      }

      return configuration.row.isMultiple(of: 2) ? even : odd
    }
  }
}
