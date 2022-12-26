import Foundation

public struct TextTracking: TextStyleProtocol {
  private let tracking: CGFloat?

  public init(_ tracking: CGFloat?) {
    self.tracking = tracking
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.tracking = self.tracking
  }
}
