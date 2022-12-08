import Foundation

public enum FontStyleAttribute: AttributedStringKey {
  public typealias Value = FontStyle
  public static let name = "fontStyle"
}

extension AttributeScopes {
  public var markdownUI: MarkdownUIAttributes.Type {
    MarkdownUIAttributes.self
  }

  public struct MarkdownUIAttributes: AttributeScope {
    public let fontStyle: FontStyleAttribute
    public let swiftUI: SwiftUIAttributes
  }
}

extension AttributeDynamicLookup {
  public subscript<T: AttributedStringKey>(
    dynamicMember keyPath: KeyPath<AttributeScopes.MarkdownUIAttributes, T>
  ) -> T {
    return self[T.self]
  }
}

extension AttributedString {
  func resolvingFontStyles() -> AttributedString {
    var output = self

    for run in output.runs {
      guard let fontStyle = run.fontStyle else {
        continue
      }

      output[run.range].font = fontStyle.resolve()
      output[run.range].fontStyle = nil
    }

    return output
  }
}
