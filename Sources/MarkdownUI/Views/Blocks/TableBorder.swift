import SwiftUI

public struct TableBorder {
  var rectangles: (_ tableBounds: TableBounds, _ borderWidth: CGFloat) -> [CGRect]
}

extension TableBorder {
  public static var outline: TableBorder {
    TableBorder { tableBounds, borderWidth in
      [tableBounds.bounds]
    }
  }

  public static var topBottomOutline: TableBorder {
    TableBorder { tableBounds, borderWidth in
      [
        CGRect(
          origin: .init(x: tableBounds.bounds.minX, y: tableBounds.bounds.minY),
          size: .init(width: tableBounds.bounds.width, height: borderWidth)
        ),
        CGRect(
          origin: .init(x: tableBounds.bounds.minX, y: tableBounds.bounds.maxY - borderWidth),
          size: .init(width: tableBounds.bounds.width, height: borderWidth)
        ),
      ]
    }
  }

  public static var horizontalGridlines: TableBorder {
    TableBorder { tableBounds, borderWidth in
      (0..<tableBounds.rowCount - 1)
        .map {
          tableBounds.bounds(forRow: $0)
            .insetBy(dx: -borderWidth, dy: -borderWidth)
        }
        .map {
          CGRect(
            origin: .init(x: $0.minX, y: $0.maxY - borderWidth),
            size: .init(width: $0.width, height: borderWidth)
          )
        }
    }
  }

  public static var verticalGridlines: TableBorder {
    TableBorder { tableBounds, borderWidth in
      (0..<tableBounds.columnCount - 1)
        .map {
          tableBounds.bounds(forColumn: $0)
            .insetBy(dx: -borderWidth, dy: -borderWidth)
        }
        .map {
          CGRect(
            origin: .init(x: $0.maxX - borderWidth, y: $0.minY),
            size: .init(width: borderWidth, height: $0.height)
          )
        }
    }
  }

  public static var gridlines: TableBorder {
    TableBorder { tableBounds, borderWidth in
      Self.horizontalGridlines.rectangles(tableBounds, borderWidth)
        + Self.verticalGridlines.rectangles(tableBounds, borderWidth)
    }
  }

  public static var horizontalLines: TableBorder {
    TableBorder { tableBounds, borderWidth in
      Self.topBottomOutline.rectangles(tableBounds, borderWidth)
        + Self.horizontalGridlines.rectangles(tableBounds, borderWidth)
    }
  }

  public static var all: TableBorder {
    TableBorder { tableBounds, borderWidth in
      Self.gridlines.rectangles(tableBounds, borderWidth)
        + Self.outline.rectangles(tableBounds, borderWidth)
    }
  }
}
