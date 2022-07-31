import CommonMark
import SwiftUI

struct MarkdownInlineGroup: View {
  @Environment(\.font) private var font
  @Environment(\.markdownInlineStyle) private var markdownInlineStyle
  // TODO: environment
  private var baseURL: URL? = nil
  // TODO: environment
  private var imageLoaders: [String: MarkdownImageLoader] = [
    "http": .networkImage,
    "https": .networkImage,
  ]
  @State private var images: [URL: SwiftUI.Image] = [:]

  private var content: [Inline]

  init(content: [Inline]) {
    self.content = content
  }

  var body: some View {
    content.render(baseURL: baseURL, font: font, style: markdownInlineStyle, images: images)
      .task { await loadImages() }
  }

  private func loadImages() async {
    let urls = content.imageURLs(relativeTo: baseURL)
    guard !urls.isEmpty else { return }

    let images: [URL: SwiftUI.Image] = await withTaskGroup(
      of: (URL, SwiftUI.Image?).self
    ) { [imageLoaders] group in
      for url in urls {
        guard let scheme = url.scheme, let imageLoader = imageLoaders[scheme] else {
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

    withAnimation {
      self.images = images
    }
  }
}

struct MarkdownInlineGroup_Previews: PreviewProvider {
  static var previews: some View {
    MarkdownInlineGroup(
      content: [
        .text("Hello,"),
        .softBreak,
        .text("World!"),
        .lineBreak,
        .code(.init("This is some code")),
        .lineBreak,
        .emphasis(.init("This text is emphasized")),
        .lineBreak,
        .strong(.init("This text is strong")),
        .lineBreak,
        .emphasis(
          .init(
            children: [
              .strong(
                .init(children: [.code(.init("Emphasized and strong code"))])
              )
            ]
          )
        ),
        .lineBreak,
        .link(
          .init("https://apple.com") {
            "This is a link"
          }
        ),
        .lineBreak,
        .image(.init("https://picsum.photos/id/223/100/150")),
      ]
    )
  }
}
