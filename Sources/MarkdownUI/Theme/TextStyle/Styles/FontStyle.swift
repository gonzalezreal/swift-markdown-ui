import Foundation

public struct FontStyle: TextStyle {
  private let style: FontProperties.Style

  public init(_ style: FontProperties.Style) {
    self.style = style
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    attributes.fontProperties?.style = self.style
  }
}
