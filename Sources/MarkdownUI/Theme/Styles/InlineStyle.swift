import SwiftUI

public struct InlineStyle {
  var transform: (inout AttributeContainer) -> Void

  public init(transform: @escaping (_ attributes: inout AttributeContainer) -> Void) {
    self.transform = transform
  }

  func transforming(_ attributes: AttributeContainer) -> AttributeContainer {
    var newAttributes = attributes
    transform(&newAttributes)
    return newAttributes
  }
}

extension InlineStyle {
  public static var unit: Self {
    .init { _ in }
  }

  public static func monospaced(size: Size = .em(1), backgroundColor: Color? = nil) -> Self {
    .init { attributes in
      attributes.fontStyle = attributes.fontStyle?.monospaced().size(size)
      attributes.backgroundColor = backgroundColor
    }
  }

  public static var italic: Self {
    .init { attributes in
      attributes.fontStyle = attributes.fontStyle?.italic()
    }
  }

  public static var bold: Self {
    .init { attributes in
      attributes.fontStyle = attributes.fontStyle?.bold()
    }
  }

  public static func weight(_ weight: Font.Weight) -> Self {
    .init { attributes in
      attributes.fontStyle = attributes.fontStyle?.weight(weight)
    }
  }

  public static var strikethrough: Self {
    .init { attributes in
      attributes.strikethroughStyle = .single
    }
  }

  public static var `subscript`: Self {
    baselineOffset(.em(-0.25), size: .em(0.75))
  }

  public static var superscript: Self {
    baselineOffset(.em(0.5), size: .em(0.75))
  }

  public static func baselineOffset(_ baselineOffset: Size, size: Size) -> Self {
    .init { attributes in
      attributes.baselineOffset = attributes.fontStyle.map { baselineOffset.points(relativeTo: $0) }
      attributes.fontStyle = attributes.fontStyle?.size(size)
    }
  }

  public static func foregroundColor(_ color: Color) -> Self {
    .init { attributes in
      attributes.foregroundColor = color
    }
  }
}
