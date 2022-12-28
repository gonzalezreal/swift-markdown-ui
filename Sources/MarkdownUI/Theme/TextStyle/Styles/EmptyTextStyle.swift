import Foundation

public struct EmptyTextStyle: TextStyle {
  public init() {}
  public func transformAttributes(_: inout AttributeContainer) {}
}
