import Foundation

public struct FontCapsVariant: TextStyle {
  private let capsVariant: FontProperties.CapsVariant

  public init(_ capsVariant: FontProperties.CapsVariant) {
    self.capsVariant = capsVariant
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    attributes.fontProperties?.capsVariant = self.capsVariant
  }
}
