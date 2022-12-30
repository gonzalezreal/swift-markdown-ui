import SwiftUI

public struct FontWeight: TextStyle {
  private let weight: Font.Weight

  public init(_ weight: Font.Weight) {
    self.weight = weight
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    attributes.fontProperties?.weight = self.weight
  }
}
