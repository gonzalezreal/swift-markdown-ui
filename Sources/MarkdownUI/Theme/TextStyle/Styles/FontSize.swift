import Foundation

public struct FontSize: TextStyleProtocol {
  private let size: Size

  public init(_ size: Size) {
    self.size = size
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    switch self.size.unit {
    case .points:
      attributes.fontProperties?.size = self.size.value
      attributes.fontProperties?.scale = 1
    case .em:
      attributes.fontProperties?.scale *= self.size.value
    case .rem:
      attributes.fontProperties?.scale = self.size.value
    }
  }
}
