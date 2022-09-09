import SwiftUI

public struct Markdown: View {
  @Environment(\.theme.baseFont) private var baseFont

  private var document: Document
  private var baseURL: URL?

  public init(_ markdown: String, baseURL: URL? = nil) {
    self.document = Document(markdown: markdown)
    self.baseURL = baseURL
  }

  public var body: some View {
    BlockGroup(document.blocks)
      .environment(\.font, baseFont)
      .environment(\.markdownBaseURL, baseURL)
  }
}

extension View {
  public func markdownTheme(_ theme: Theme) -> some View {
    environment(\.theme, theme)
  }

  public func markdownTheme<V>(
    _ keyPath: WritableKeyPath<Theme, V>, _ value: V
  ) -> some View {
    environment((\EnvironmentValues.theme).appending(path: keyPath), value)
  }
}
