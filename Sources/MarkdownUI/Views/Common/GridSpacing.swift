import SwiftUI

public struct GridSpacing: Equatable {
  public var horizontal: CGFloat
  public var vertical: CGFloat

  public init(horizontal: CGFloat, vertical: CGFloat) {
    self.horizontal = horizontal
    self.vertical = vertical
  }
}

extension GridSpacing {
  public static var defaultImageFlow: GridSpacing {
    GridSpacing(
      horizontal: floor(Font.TextStyle.body.pointSize / 4),
      vertical: floor(Font.TextStyle.body.pointSize / 4)
    )
  }
}
