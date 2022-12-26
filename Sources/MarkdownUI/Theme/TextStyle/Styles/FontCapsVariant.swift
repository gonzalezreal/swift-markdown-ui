import Foundation

public struct FontCapsVariant: TextStyleProtocol {
  private let capsVariant: FontProperties.CapsVariant

  public init(_ capsVariant: FontProperties.CapsVariant) {
    self.capsVariant = capsVariant
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.fontProperties?.capsVariant = self.capsVariant
  }
}
