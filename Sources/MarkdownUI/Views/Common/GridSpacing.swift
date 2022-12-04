import SwiftUI

public struct GridSpacing: Equatable {
  public var horizontal: CGFloat
  public var vertical: CGFloat

  public init(horizontal: CGFloat, vertical: CGFloat) {
    self.horizontal = horizontal
    self.vertical = vertical
  }

  func absolute(fontSize: CGFloat) -> GridSpacing {
    .init(
      horizontal: round(self.horizontal * fontSize),
      vertical: round(self.vertical * fontSize)
    )
  }
}

extension GridSpacing {
  public static var defaultImageFlow: GridSpacing {
    GridSpacing(horizontal: 0.25, vertical: 0.25)
  }
}
