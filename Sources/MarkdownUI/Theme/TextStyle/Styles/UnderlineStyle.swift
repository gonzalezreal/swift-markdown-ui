import SwiftUI

public struct UnderlineStyle: TextStyle {
  private let lineStyle: Text.LineStyle?

  public init(_ lineStyle: Text.LineStyle?) {
    self.lineStyle = lineStyle
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.underlineStyle = self.lineStyle
  }
}
