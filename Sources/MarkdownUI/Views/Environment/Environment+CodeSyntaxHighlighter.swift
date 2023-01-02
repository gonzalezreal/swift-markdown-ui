import SwiftUI

extension View {
  public func markdownCodeSyntaxHighlighter(
    _ codeSyntaxHighlighter: CodeSyntaxHighlighter
  ) -> some View {
    self.environment(\.codeSyntaxHighlighter, codeSyntaxHighlighter)
  }
}

extension EnvironmentValues {
  var codeSyntaxHighlighter: CodeSyntaxHighlighter {
    get { self[CodeSyntaxHighlighterKey.self] }
    set { self[CodeSyntaxHighlighterKey.self] = newValue }
  }
}

private struct CodeSyntaxHighlighterKey: EnvironmentKey {
  static let defaultValue: CodeSyntaxHighlighter = .plainText
}
