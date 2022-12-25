import SwiftUI

public protocol CodeSyntaxHighlighter {
  func highlightCode(_ code: String, language: String?) -> Text
}

public struct PlainCodeSyntaxHighlighter: CodeSyntaxHighlighter {
  public init() {}

  public func highlightCode(_ code: String, language: String?) -> Text {
    Text(code)
  }
}

extension CodeSyntaxHighlighter where Self == PlainCodeSyntaxHighlighter {
  public static var plain: Self {
    PlainCodeSyntaxHighlighter()
  }
}
