import SwiftUI

public struct ForegroundColor: TextStyle {
  private let foregroundColor: Color?

  public init(_ foregroundColor: Color?) {
    self.foregroundColor = foregroundColor
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.foregroundColor = self.foregroundColor
  }
}
