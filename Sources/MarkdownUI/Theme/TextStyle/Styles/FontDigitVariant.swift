import Foundation

public struct FontDigitVariant: TextStyle {
  private let digitVariant: FontProperties.DigitVariant

  public init(_ digitVariant: FontProperties.DigitVariant) {
    self.digitVariant = digitVariant
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.fontProperties?.digitVariant = self.digitVariant
  }
}
