import Foundation

extension AttributeScopes {
  struct LaTeXAttributes: AttributeScope {
    let latexContent: LaTeXContentAttribute
    let isDisplayLaTeX: IsDisplayLaTeXAttribute
  }

  var laTeX: LaTeXAttributes.Type { LaTeXAttributes.self }
}

extension AttributeDynamicLookup {
  subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.LaTeXAttributes, T>) -> T
  where T: AttributedStringKey {
    self[T.self]
  }
}

enum LaTeXContentAttribute: AttributedStringKey {
  typealias Value = String
  static let name = "latexContent"
}

enum IsDisplayLaTeXAttribute: AttributedStringKey {
  typealias Value = Bool
  static let name = "isDisplayLaTeX"
}
