import CommonMark
import SwiftUI

struct MarkdownInlineGroup: View {
  @Environment(\.markdownBaseURL) private var markdownBaseURL
  @Environment(\.markdownInlineStyle) private var markdownInlineStyle
  @Environment(\.markdownImageLoaders) private var markdownImageLoaders
  @Environment(\.font) private var font

  @State private var images: [URL: SwiftUI.Image] = [:]

  private var content: [Inline]

  init(content: [Inline]) {
    self.content = content
  }

  var body: some View {
    content.render(baseURL: markdownBaseURL, font: font, style: markdownInlineStyle, images: images)
      .task { await loadImages() }
  }

  private func loadImages() async {
    let urls = content.imageURLs(relativeTo: markdownBaseURL)
    guard !urls.isEmpty else { return }

    self.images = await withTaskGroup(
      of: (URL, SwiftUI.Image?).self
    ) { [markdownImageLoaders] group in
      for url in urls {
        guard let scheme = url.scheme, let imageLoader = markdownImageLoaders[scheme] else {
          continue
        }
        group.addTask {
          (url, await imageLoader.image(for: url))
        }
      }

      var images = [URL: SwiftUI.Image]()

      for await (url, image) in group {
        images[url] = image
      }

      return images
    }
  }
}

extension EnvironmentValues {
  var markdownBaseURL: URL? {
    get { self[MarkdownBaseURLKey.self] }
    set { self[MarkdownBaseURLKey.self] = newValue }
  }
}

private struct MarkdownBaseURLKey: EnvironmentKey {
  static var defaultValue: URL? = nil
}
