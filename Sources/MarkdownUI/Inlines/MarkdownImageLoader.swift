import SwiftUI

public protocol MarkdownImageLoader {
  func image(for url: URL) async -> SwiftUI.Image?
}

extension View {
  public func markdownImageLoader<L: MarkdownImageLoader>(
    _ markdownImageLoader: L,
    forURLScheme urlScheme: String
  ) -> some View {
    environment(\.markdownImageLoaders, [urlScheme: markdownImageLoader])
  }
}

extension EnvironmentValues {
  var markdownImageLoaders: [String: MarkdownImageLoader] {
    get { self[MarkdownImageLoadersKey.self] }
    set { self[MarkdownImageLoadersKey.self].merge(newValue) { _, new in new } }
  }
}

private struct MarkdownImageLoadersKey: EnvironmentKey {
  static let defaultValue: [String: MarkdownImageLoader] = [
    "http": .networkImage,
    "https": .networkImage,
  ]
}
