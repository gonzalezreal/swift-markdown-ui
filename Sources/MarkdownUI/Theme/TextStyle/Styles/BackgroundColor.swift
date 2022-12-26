import SwiftUI

public struct BackgroundColor: TextStyleProtocol {
  private let backgroundColor: Color?

  public init(_ backgroundColor: Color?) {
    self.backgroundColor = backgroundColor
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.backgroundColor = self.backgroundColor
  }
}
