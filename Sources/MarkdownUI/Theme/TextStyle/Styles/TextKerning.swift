import Foundation

public struct TextKerning: TextStyle {
  private let kern: CGFloat?

  public init(_ kern: CGFloat?) {
    self.kern = kern
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    attributes.kern = self.kern
  }
}
