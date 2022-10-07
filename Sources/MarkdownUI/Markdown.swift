import SwiftUI

public struct Markdown<Content: BlockContent>: View {
  @Environment(\.theme.baseFont) private var baseFont

  private let baseURL: URL?
  private let imageTransaction: Transaction
  private let content: Content

  public init(
    baseURL: URL? = nil,
    imageTransaction: Transaction = .init(),
    @BlockContentBuilder content: () -> Content
  ) {
    self.baseURL = baseURL
    self.imageTransaction = imageTransaction
    self.content = content()
  }

  public var body: some View {
    content.render()
      .environment(\.font, baseFont)
      .environment(\.markdownBaseURL, baseURL)
      .environment(\.imageTransaction, imageTransaction)
  }
}

extension Markdown where Content == _ContentSequence<Block> {
  public init(_ markdown: String, baseURL: URL? = nil, imageTransaction: Transaction = .init()) {
    self.baseURL = baseURL
    self.imageTransaction = imageTransaction
    self.content = _ContentSequence(markdown: markdown)
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

  public func markdownImageLoader(
    _ imageLoader: ImageLoader?,
    forURLScheme urlScheme: String
  ) -> some View {
    environment(\.imageLoaderRegistry[urlScheme], imageLoader)
  }
}
