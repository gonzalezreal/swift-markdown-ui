import Foundation

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
  static var unit: Self {
    .init { _ in }
  }

  public static var monospaced: Self {
    .init { attributes in
      attributes.font = attributes.font?.monospaced()
    }
  }

  public static var italic: Self {
    .init { attributes in
      attributes.font = attributes.font?.italic()
    }
  }

  public static var bold: Self {
    .init { attributes in
      attributes.font = attributes.font?.bold()
    }
  }

  public static var strikethrough: Self {
    .init { attributes in
      attributes.strikethroughStyle = .single
    }
  }
}
