import SwiftUI

public struct StrikethroughStyle: TextStyle {
  private let lineStyle: Text.LineStyle?

  public init(_ lineStyle: Text.LineStyle?) {
    self.lineStyle = lineStyle
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    attributes.strikethroughStyle = self.lineStyle
  }
}
