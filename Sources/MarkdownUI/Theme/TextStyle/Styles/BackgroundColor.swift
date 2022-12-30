import SwiftUI

public struct BackgroundColor: TextStyle {
  private let backgroundColor: Color?

  public init(_ backgroundColor: Color?) {
    self.backgroundColor = backgroundColor
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    attributes.backgroundColor = self.backgroundColor
  }
}
