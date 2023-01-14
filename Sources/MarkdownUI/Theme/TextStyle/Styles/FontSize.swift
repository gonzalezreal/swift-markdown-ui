import Foundation

public struct FontSize: TextStyle {
  private enum Size {
    case points(CGFloat)
    case relative(RelativeSize)
  }

  private let size: Size

  public init(_ relativeSize: RelativeSize) {
    self.size = .relative(relativeSize)
  }

  public init(_ size: CGFloat) {
    self.size = .points(size)
  }

  public func collectAttributes(in attributes: inout AttributeContainer) {
    switch self.size {
    case .points(let value):
      attributes.fontProperties?.size = value
      attributes.fontProperties?.scale = 1
    case .relative(let relativeSize):
      switch relativeSize.unit {
      case .em:
        attributes.fontProperties?.scale *= relativeSize.value
      case .rem:
        attributes.fontProperties?.scale = relativeSize.value
      }
    }
  }
}
