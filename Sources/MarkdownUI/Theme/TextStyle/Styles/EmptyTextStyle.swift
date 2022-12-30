import Foundation

public struct EmptyTextStyle: TextStyle {
  public init() {}
  public func collectAttributes(in: inout AttributeContainer) {}
}
