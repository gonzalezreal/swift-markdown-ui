import SwiftUI

public struct Size: Hashable {
  enum Unit: Hashable {
    case points
    case em
    case rem
  }

  var value: CGFloat
  var unit: Unit
}

extension Size {
  public static let zero = Size(value: 0, unit: .points)

  public static func points(_ value: CGFloat) -> Size {
    .init(value: value, unit: .points)
  }

  public static func em(_ value: CGFloat) -> Size {
    .init(value: value, unit: .em)
  }

  public static func rem(_ value: CGFloat) -> Size {
    .init(value: value, unit: .rem)
  }

  public func points(relativeTo fontProperties: FontProperties? = nil) -> CGFloat {
    let fontProperties = fontProperties ?? .init()

    switch self.unit {
    case .points:
      return value
    case .em:
      return round(value * fontProperties.scaledSize)
    case .rem:
      return round(value * fontProperties.size)
    }
  }
}

extension View {
  public func relativeFrame(
    width: Size? = nil,
    height: Size? = nil,
    alignment: Alignment = .center
  ) -> some View {
    TextStyleAttributesReader { attributes in
      self.frame(
        width: width?.points(relativeTo: attributes.fontProperties),
        height: height?.points(relativeTo: attributes.fontProperties),
        alignment: alignment
      )
    }
  }

  public func relativeFrame(minWidth: Size, alignment: Alignment = .center) -> some View {
    TextStyleAttributesReader { attributes in
      self.frame(
        minWidth: minWidth.points(relativeTo: attributes.fontProperties),
        alignment: alignment
      )
    }
  }

  public func relativePadding(_ edges: Edge.Set = .all, length: Size) -> some View {
    TextStyleAttributesReader { attributes in
      self.padding(edges, length.points(relativeTo: attributes.fontProperties))
    }
  }

  public func relativeLineSpacing(_ lineSpacing: Size) -> some View {
    TextStyleAttributesReader { attributes in
      self.lineSpacing(lineSpacing.points(relativeTo: attributes.fontProperties))
    }
  }
}
