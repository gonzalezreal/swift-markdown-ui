import Foundation

enum FontStyleAttribute: AttributedStringKey {
  typealias Value = FontStyle
  static let name = "fontStyle"
}

extension AttributeScopes {
  var markdownUI: MarkdownUIAttributes.Type {
    MarkdownUIAttributes.self
  }

  struct MarkdownUIAttributes: AttributeScope {
    let fontStyle: FontStyleAttribute
    let swiftUI: SwiftUIAttributes
  }
}

extension AttributedString {
  func resolvingFontStyles() -> AttributedString {
    var output = self

    for run in output.runs {
      guard let fontStyle = run.markdownUI.fontStyle else {
        continue
      }

      output[run.range].font = fontStyle.resolve()
      output[run.range].markdownUI.fontStyle = nil
    }

    return output
  }
}
