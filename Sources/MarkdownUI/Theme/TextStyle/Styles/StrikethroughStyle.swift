import SwiftUI

public struct StrikethroughStyle: TextStyleProtocol {
  private let lineStyle: Text.LineStyle?

  public init(_ lineStyle: Text.LineStyle?) {
    self.lineStyle = lineStyle
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.strikethroughStyle = self.lineStyle
  }
}
