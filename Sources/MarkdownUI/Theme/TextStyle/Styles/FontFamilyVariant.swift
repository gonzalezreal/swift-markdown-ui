import Foundation

public struct FontFamilyVariant: TextStyle {
  private let familyVariant: FontProperties.FamilyVariant

  public init(_ familyVariant: FontProperties.FamilyVariant) {
    self.familyVariant = familyVariant
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.fontProperties?.familyVariant = self.familyVariant
  }
}
