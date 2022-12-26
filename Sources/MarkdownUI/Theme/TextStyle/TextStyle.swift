import Foundation

public struct TextStyle: TextStyleProtocol {
  private let textStyle: any TextStyleProtocol

  public init<S: TextStyleProtocol>(_ textStyle: S) {
    self.textStyle = textStyle
  }

  public init<S: TextStyleProtocol>(@TextStyleBuilder textStyle: () -> S) {
    self.init(textStyle())
  }

  public func transformAttributes(_ attributes: inout AttributeContainer) {
    self.textStyle.transformAttributes(&attributes)
  }
}
