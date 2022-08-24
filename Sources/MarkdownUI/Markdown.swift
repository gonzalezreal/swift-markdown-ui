import SwiftUI

public struct Markdown: View {
  private var document: Document
  private var baseURL: URL?

  public init(_ markdown: String, baseURL: URL? = nil) {
    self.document = Document(markdown: markdown)
    self.baseURL = baseURL
  }

  public var body: some View {
    BlockGroup(document.blocks)
      .environment(\.markdownBaseURL, baseURL)
  }
}

extension View {
  public func markdownSpacing(_ markdownSpacing: CGFloat? = nil) -> some View {
    environment(\.markdownSpacing, markdownSpacing)
  }
}
