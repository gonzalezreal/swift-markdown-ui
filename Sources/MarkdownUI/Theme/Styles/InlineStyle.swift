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
}
