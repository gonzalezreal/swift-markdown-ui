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

  public func points(relativeTo fontStyle: FontStyle) -> CGFloat {
    switch self.unit {
    case .points:
      return value
    case .em:
      return round(value * fontStyle.size)
    case .rem:
      return round(value * fontStyle.baseSize)
    }
  }
}

extension View {
  public func frame(minWidth: Size, alignment: Alignment = .center) -> some View {
    self.modifier(FrameModifier(minWidth: minWidth, alignment: alignment))
  }

  public func padding(_ edges: Edge.Set = .all, _ length: Size) -> some View {
    self.modifier(PaddingModifier(edges: edges, length: length))
  }

  public func lineSpacing(_ lineSpacing: Size) -> some View {
    self.modifier(LineSpacingModifier(lineSpacing: lineSpacing))
  }
}

private struct FrameModifier: ViewModifier {
  @Environment(\.fontStyle) private var fontStyle

  let minWidth: Size
  let alignment: Alignment

  func body(content: Content) -> some View {
    content.frame(
      minWidth: self.minWidth.points(relativeTo: self.fontStyle),
      alignment: self.alignment
    )
  }
}

private struct PaddingModifier: ViewModifier {
  @Environment(\.fontStyle) private var fontStyle

  let edges: Edge.Set
  let length: Size

  func body(content: Content) -> some View {
    content.padding(self.edges, length.points(relativeTo: self.fontStyle))
  }
}

private struct LineSpacingModifier: ViewModifier {
  @Environment(\.fontStyle) private var fontStyle

  let lineSpacing: Size

  func body(content: Content) -> some View {
    content.lineSpacing(self.lineSpacing.points(relativeTo: self.fontStyle))
  }
}
