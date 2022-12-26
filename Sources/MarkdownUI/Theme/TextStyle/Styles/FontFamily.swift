import Foundation

public struct FontFamily: TextStyleProtocol {
  private let family: FontProperties.Family

  public init(_ family: FontProperties.Family) {
    self.family = family
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.fontProperties?.family = self.family
  }
}
