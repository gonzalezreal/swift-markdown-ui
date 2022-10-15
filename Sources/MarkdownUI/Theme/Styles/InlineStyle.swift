import SwiftUI

public struct InlineStyle {
  var update: (inout AttributeContainer) -> Void

  public init(update: @escaping (inout AttributeContainer) -> Void) {
    self.update = update
  }

  func updating(_ attributes: AttributeContainer) -> AttributeContainer {
    var newAttributes = attributes
    update(&newAttributes)
    return newAttributes
  }
}

extension InlineStyle {
  public static var `default`: Self {
    .init { _ in }
  }

  public static var monospaced: Self {
    .monospaced()
  }

  public static func monospaced(backgroundColor: Color? = nil) -> Self {
    .init { attributes in
      attributes.font = attributes.font?.monospaced()
      attributes.backgroundColor = backgroundColor
    }
  }

  public static var italic: Self {
    .init { attributes in
      attributes.font = attributes.font?.italic()
    }
  }

  public static var italicUnderline: Self {
    .init { attributes in
      attributes.font = attributes.font?.italic()
      attributes.underlineStyle = .single
    }
  }

  public static var bold: Self {
    .init { attributes in
      attributes.font = attributes.font?.bold()
    }
  }

  public static func weight(_ weight: Font.Weight) -> Self {
    .init { attributes in
      attributes.font = attributes.font?.weight(weight)
    }
  }

  public static var strikethrough: Self {
    .init { attributes in
      attributes.strikethroughStyle = .single
    }
  }

  public static var redacted: Self {
    .init { attributes in
      attributes.foregroundColor = .primary
      attributes.backgroundColor = .primary
    }
  }

  public static var underlineDot: Self {
    .init { attributes in
      attributes.underlineStyle = .init(pattern: .dot)
    }
  }
}
