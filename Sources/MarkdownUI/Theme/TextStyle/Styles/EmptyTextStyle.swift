import Foundation

public struct EmptyTextStyle: TextStyleProtocol {
  public init() {}
  public func transformAttributes(_: inout AttributeContainer) {}
}
